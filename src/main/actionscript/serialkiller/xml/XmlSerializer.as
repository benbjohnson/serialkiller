package serialkiller.xml
{
import serialkiller.core.Inflector;
import serialkiller.core.Type;
import serialkiller.utils.DateUtil;

import flash.errors.IllegalOperationError;
import flash.events.EventDispatcher;

/**
 *  This class is used for serializing data sent to and from the Rails
 *	framework through XML.
 */
public class XmlSerializer extends EventDispatcher
{
	//-------------------------------------------------------------------------
	//
	//  Constructor
	//
	//-------------------------------------------------------------------------

	/**
	 *  Constructor.
	 */
	public function XmlSerializer()
	{
		super();
	}
	

	//-------------------------------------------------------------------------
	//
	//  Methods
	//
	//-------------------------------------------------------------------------

    //---------------------------------
    //  Serialization
    //---------------------------------
		
	/**
	 *	Serializes an object into XML.
	 *	
	 *	<p>The <code>options</code> object is used for specifying exactly
	 *	what nodes should be output to XML. The <code>include</code> option
	 *	allows for specifying what associations to display. The
	 *	<code>only</code> specifies what basic properties will be output.
	 *	The <code>except</code> lists what basic properties will not be
	 *	output.</p>
	 *	
	 *	@param data     The data object to serialize.
	 *	@param name     The node name.
	 *	@param options  Additional options for formatting the XML output.
	 *	
	 *	@return         An XML representation of the data object.
	 */
	public function toXml(data:*, options:Object=null):XML
	{
		var xml:XML;
		
		// Return null if we have no data
		if(data == null) {
			return null;
		}
		else if(data is Array) {
			xml = <list type="array"/>;
			for each(var item:Object in data) {
				xml.appendChild(toXml(item));
			}
		}
		else {
			// Create root node
			var type:XML = Type.describeType(data);
			var className:String = type.@name.split("::").pop();
			var localName:String = Inflector.dasherize(Inflector.underscore(className));
			xml = new XML("<" + localName + "/>");
		
			// Loop over properties and add to xml
			var field:XML;
			for each(field in type.variable) {
				fieldToXml(data, xml, field, options);
			}
			for each(field in type.accessor) {
				fieldToXml(data, xml, field, options);
			}
		}
		
		return xml;
	}
	
	/**
	 *	Formats and adds an individual field for XML serialization.
	 *	
	 *	@param data     The data object that is being serialized.
	 *	@param xml      The XML node that the field will be added to.
	 *	@param field    The field that is being serialized.
	 *	@param options  The options for XML output.
	 */
	protected function fieldToXml(data:Object, xml:XML,
								  field:XML, options:Object):void
	{
		// Make sure field is not a nonreadable accessor
		if(field.@access == "writeonly") {
			return;
		}
		// Make sure the field isn't transient
		else if(hasMetaData(field, "Transient")) {
			return;
		}
		// Make sure it's not a system property
		else if(field.@name == "prototype") {
			return;
		}

		// Format
		var value:Object = data[field.@name];
		var clazz:String = field.@type;

		// Serialize primitives
		if(isPrimitive(clazz))
		{
			// Check options for primitives
			if(options != null) {
				// Exit if 'only' option is specified and the field isn't included
				if(options.only is Array && options.only.indexOf(field.@name.toString()) == -1) {
					return;
				}
				// Exit if 'except' option is specified and the field is included
				else if(options.except is Array && options.except.indexOf(field.@name.toString()) != -1) {
					return;
				}
			}

			// Serialize primitives
			switch(clazz) {
				case "String":  toFieldXml_String(value, xml, field); return;
				case "Number":  toFieldXml_Number(value, xml, field); return;
				case "int":
				case "uint":    toFieldXml_int(value, xml, field); return;
				case "Boolean": toFieldXml_Boolean(value, xml, field); return;
				case "Date":    toFieldXml_Date(value, xml, field); return;
			}
		}
		// Serialize complex objects
		else {
			// Make sure the following types are specifically included
			var suboptions:Object = (options && options.inc ? options.inc[field.@name] : null)
			if(suboptions != null) {
				// Serialize collection and object types
				if(clazz == "Array") {
					toFieldXml_collection(value, xml, field, suboptions);
				}
				else {
					toFieldXml_Object(value, xml, field, suboptions);
				}
			}
		}
	}
	
	/** @private */
	protected function toFieldXml_String(data:Object, xml:XML, field:XML):void
	{
		var localName:String = Inflector.dasherize(Inflector.underscore(field.@name));
		if(data == null) {
			xml[localName].@nil = "true";
		}
		else {
			xml[localName] = data;
		}
	}

	/** @private */
	protected function toFieldXml_Number(data:Object, xml:XML, field:XML):void
	{
		var localName:String = Inflector.dasherize(Inflector.underscore(field.@name));
		var dataType:String = getFieldDataType(field) || "float";

		// Create node
		xml[localName].@type = dataType;

		if(isNaN(data as Number)) {
			xml[localName].@nil = "true";
		}
		else {
			if(dataType == "integer") {
				xml[localName] = int(data as Number);
			}
			else {
				xml[localName] = data;
			}
		}
	}

	/** @private */
	protected function toFieldXml_int(data:Object, xml:XML, field:XML):void
	{
		var localName:String = Inflector.dasherize(Inflector.underscore(field.@name));
		xml[localName].@type = "integer";
		xml[localName] = data;
	}

	/** @private */
	protected function toFieldXml_Boolean(data:Object, xml:XML, field:XML):void
	{
		var localName:String = Inflector.dasherize(Inflector.underscore(field.@name));
		xml[localName].@type = "boolean";
		xml[localName] = (data ? "true" : "false");
	}

	/** @private */
	protected function toFieldXml_Date(data:Object, xml:XML, field:XML):void
	{
		var localName:String = Inflector.dasherize(Inflector.underscore(field.@name));
		var dataType:String = getFieldDataType(field) || "date";
		
		// Convert to UTC for formatter
		var value:Date = data as Date;
		
		// Create node
		xml[localName].@type = dataType;
		
		if(value == null) {
			xml[localName].@nil = "true";
		}
		else {
			if(dataType == "date") {
				xml[localName] = DateUtil.formatDate(value);
			}
			else if(dataType == "datetime") {
				xml[localName] = DateUtil.formatDateTime(value);
			}
		}
	}

	/** @private */
	protected function toFieldXml_collection(data:Object, xml:XML, field:XML, options:Object):void
	{
		var localName:String = Inflector.dasherize(Inflector.underscore(field.@name));

		if(data != null) {
			xml[localName].@type = "array";
			for each(var item:Object in data) {
				xml[localName].appendChild(toXml(item, options));
			}
		}
		else {
			xml[localName].@type = "array";
			xml[localName].@nil = "true";
		}
	}

	/** @private */
	protected function toFieldXml_Object(data:Object, xml:XML, field:XML, options:Object):void
	{
		var localName:String = Inflector.dasherize(Inflector.underscore(field.@name));
		
		if(data != null) {
			var child:XML = toXml(data, options);
			child.setLocalName(localName);
			xml[localName] = child;
		}
		else {
			xml[localName].@nil = "true";
		}
	}


    //---------------------------------
    //  Deserialization
    //---------------------------------

	/**
	 *	Parses an XML object and appropriately marshalls data types and
	 *	typed objects.
	 *	
	 *	@param xml      The XML to parse.
	 *	@param options  A list of options for deserializing the XML.
	 *	
	 *	@return     A typed object.
	 */
	public function fromXml(xml:XML):*
	{
		var data:Object;
		var localName:String;
		var className:String;
		
		// Return null if we have no XML
		if(xml == null) {
			return null;
		}
		// If we have a collection, loop over it
		else if(xml.@type == "array") {
			data = new Array();
			for each(var child:XML in xml.children()) {
				data.push(fromXml(child));
			}
		}
		// Otherwise deserialize the object
		else {
			// Create object
			localName = xml.name().localName;
			className = Inflector.camelize(Inflector.underscore(localName));
			data = Type.newObject(className);

			// Throw error if class could not be found
			if(data == null) {
				throw new IllegalOperationError("Could not find class: " + className);
			}
		
			// Loop over properties and parse from xml
			var type:XML = Type.describeType(data);
			var field:XML;
			for each(field in type.accessor) {
				fieldFromXml(xml, data, field);
			}
			for each(field in type.variable) {
				fieldFromXml(xml, data, field);
			}
		}
		
		return data;
	}

	/**
	 *	Parses an individual field for XML deserialization.
	 *	
	 *	@param xml      The XML node that is being deserialized.
	 *	@param data     The data object that is being created.
	 *	@param field    The field that is being serialized.
	 */
	protected function fieldFromXml(xml:XML, data:Object, field:XML):void
	{
		// Make sure field is not a nonreadable accessor
		if(field.@access == "writeonly") {
			return;
		}
		// Make sure the field isn't transient
		else if(hasMetaData(field, "Transient")) {
			return;
		}
		// Make sure it's not a system property
		else if(field.@name == "prototype") {
			return;
		}

		// Format
		var clazz:String = field.@type;

		// Serialize primitives
		switch(clazz) {
			case "String":  fromFieldXml_String(xml, data, field); return;
			case "Number":  fromFieldXml_Number(xml, data, field); return;
			case "int":
			case "uint":    fromFieldXml_int(xml, data, field); return;
			case "Boolean": fromFieldXml_Boolean(xml, data, field); return;
			case "Date":    fromFieldXml_Date(xml, data, field); return;
		}

		// Deserialize collection and object types
		if(clazz == "Array") {
			fromFieldXml_collection(xml, data, field);
		}
		else {
			fromFieldXml_Object(xml, data, field);
		}
	}
	
	/** @private */
	protected function fromFieldXml_String(xml:XML, data:Object, field:XML):void
	{
		var localName:String = Inflector.dasherize(Inflector.underscore(field.@name));
		if(xml[localName].@nil == "true") {
			data[field.@name] = null;
		}
		else {
			data[field.@name] = xml[localName].toString();
		}
	}

	/** @private */
	protected function fromFieldXml_Number(xml:XML, data:Object, field:XML):void
	{
		var localName:String = Inflector.dasherize(Inflector.underscore(field.@name));
		var dataType:String = xml[localName].@type;

		// If nil, populate NaN (which converts to 0 for ints)
		if(xml[localName].@nil == "true") {
			data[field.@name] = NaN;
		}
		// Otherwise populate field
		else {
			if(dataType == "integer") {
				data[field.@name] = parseInt(xml[localName]);
			}
			else {
				data[field.@name] = parseFloat(xml[localName]);
			}
		}
	}

	/** @private */
	protected function fromFieldXml_int(xml:XML, data:Object, field:XML):void
	{
		var localName:String = Inflector.dasherize(Inflector.underscore(field.@name));
		data[field.@name] = parseInt(xml[localName]);
	}

	/** @private */
	protected function fromFieldXml_Boolean(xml:XML, data:Object, field:XML):void
	{
		var localName:String = Inflector.dasherize(Inflector.underscore(field.@name));
		data[field.@name] = (xml[localName] == "true");
	}

	/** @private */
	protected function fromFieldXml_Date(xml:XML, data:Object, field:XML):void
	{
		var localName:String = Inflector.dasherize(Inflector.underscore(field.@name));
		var dataType:String = xml[localName].@type || "date";
		
		// Create node
		if(xml[localName].length() > 0) {
			if(xml[localName].@nil == "true") {
				data[field.@name] = null;
			}
			else {
				var match:Array;
			
				// Match data
				if(dataType == "date") {
					data[field.@name] = DateUtil.parseDate(xml[localName].toString());
				}
				else if(dataType == "datetime") {
					data[field.@name] = DateUtil.parseDateTime(xml[localName].toString());
				}
			}
		}
	}

	/** @private */
	protected function fromFieldXml_collection(xml:XML, data:Object, field:XML):void
	{
		var localName:String = Inflector.dasherize(Inflector.underscore(field.@name));
		var items:Array = new Array();

		// Loop over array if it's not nil
		if(xml[localName].@nil != "true") {
			for each(var child:XML in xml[localName].children()) {
				var item:Object = fromXml(child);
				items.push(item);
			}
		}
		
		// Convert list to appropriate object
		if(field.@type == "Array") {
			data[field.@name] = items;
		}
	}

	/** @private */
	protected function fromFieldXml_Object(xml:XML, data:Object, field:XML):void
	{
		var localName:String = Inflector.dasherize(Inflector.underscore(field.@name));
		
		if(xml[localName].length == 0 || xml[localName].@nil == "true") {
			data[field.@name] = null;
		}
		else {
			var child:Object = fromXml(xml[localName][0]);
			data[field.@name] = child;
		}
	}


    //---------------------------------
    //  Utilities
    //---------------------------------

	/** @private */
	protected function hasMetaData(xml:XML, name:String):Boolean
	{
		for each(var metaDataXml:XML in xml.metadata) {
			if(metaDataXml.@name == name) {
				return true;
			}
		}
		return false;
	}

	/** @private */
	protected function getMetaDataArg(xml:XML, name:String, key:String):String
	{
		// Loop over meta tags
		for each(var metaDataXml:XML in xml.metadata) {
			if(metaDataXml.@name == name) {
				// Loop over arguments in meta tag
				for each(var metaDataArgXml:XML in metaDataXml.arg) {
					if(metaDataArgXml.@key == key) {
						return metaDataArgXml.@value;
					}
				}
			}
		}

		return null;
	}

	/** @private */
	protected function isPrimitive(clazz:String):Boolean
	{
		return (clazz == "String" || clazz == "Number" || clazz == "int" ||
				clazz == "uint" || clazz == "Boolean" || clazz == "Date");
	}
	
	/** @private */
	protected function getFieldDataType(field:XML):String
	{
		// Locate the data type in the meta data
		if(hasMetaData(field, "DataType"))
		{
			if(getMetaDataArg(field, "DataType", "")) {
				return getMetaDataArg(field, "DataType", "");
			}
			else if(getMetaDataArg(field, "DataType", "type")) {
				return getMetaDataArg(field, "DataType", "type");
			}
		}
		
		// If not found, return null
		return null;
	}
}
}
