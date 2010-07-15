package serialkiller.core
{
import flash.utils.Dictionary;
import flash.utils.describeType;
import flash.utils.getDefinitionByName;

/**
 *  This class is used for caching type descriptors.
 */
public class Type
{
	//-------------------------------------------------------------------------
	//
	//  Static properties
	//
	//-------------------------------------------------------------------------

	/**
	 *	A lookup of descriptors by class name.
	 */
	static private var descriptors:Dictionary = new Dictionary();
	
	/**
	 *	A list of class paths to use when instantiating classes.
	 */
	static public var classPath:Array = [];
	
	
	//-------------------------------------------------------------------------
	//
	//  Static methods
	//
	//-------------------------------------------------------------------------

	/**
	 *	Retrieves an xml descriptor of a class.
	 */
	static public function describeType(value:*):XML
	{
		// Generate new descriptor if not cached
		if(!descriptors[value]) {
			descriptors[value] = flash.utils.describeType(value);
		}

		return descriptors[value] as XML;
	}


	/**
	 *	Create an object by fully qualified class name.
	 *	
	 *	@param className  The name of the class to instantiate.
	 *	
	 *	@return           An instance of the specified class.
	 */
	static public function newObject(className:String):Object
	{
		// Loop over class paths to find class
		var classRef:Class;
		for each(var path:String in classPath)
		{
			// Try to find class
			try {
				var qualifiedClassName:String = (path != "" ? path + "." : "") + className;
				classRef = getDefinitionByName(qualifiedClassName) as Class;
				break;
			}
			catch(e:ReferenceError) {}
		}
		
		// Instatiate class if we found one
		return (classRef != null ? new classRef() : null);
	}
}
}