package serialkiller.core
{
import flash.errors.IllegalOperationError;

/**
 *  This class is used for performing code-based and English-based inflection
 *	on strings.
 */
public class Inflector
{
	//-------------------------------------------------------------------------
	//
	//  Static properties
	//
	//-------------------------------------------------------------------------

	/**
	 *	A list of pluralizing rules.
	 */
	static public var plurals:Array = [
	    [/(p)erson$/i, '$1eople'],
	    [/(m)an$/i, '$1en'],
	    [/(c)hild$/i, '$1hildren'],
	    [/(s)ex$/i, '$1exes'],
	    [/(m)ove$/i, '$1oves'],
		[/(quiz)$/i, '$1zes'],
		[/^(ox)$/i, '$1en'],
		[/([m|l])ouse$/i, '$1ice'],
		[/(matr|vert|ind)(?:ix|ex)$/i, '$1ices'],
		[/(x|ch|ss|sh)$/i, '$1es'],
		[/([^aeiouy]|qu)y$/i, '$1ies'],
		[/(hive)$/i, '$1s'],
		[/(?:([^f])fe|([lr])f)$/i, '$1$2ves'],
		[/sis$/i, 'ses'],
		[/([ti])um$/i, '$1a'],
		[/(buffal|tomat)o$/i, '$1oes'],
		[/(bu)s$/i, '$1ses'],
		[/(alias|status)$/i, '$1es'],
		[/(cact|octop|vir)us$/i, '$1i'],
		[/(ax|test)is$/i, '$1es'],
		[/s$/i, 's'],
		[/$/, 's'],
	];

	/**
	 *	A list of singular rules.
	 */
	static public var singulars:Array = [
	    [/(p)eople$/i, '$1erson'],
	    [/(m)en$/i, '$1an'],
	    [/(c)hildren$/i, '$1hild'],
	    [/(s)exes$/i, '$1ex'],
	    [/(m)oves$/i, '$1ove'],
		[/(database)s$/i, '$1'],
		[/(quiz)zes$/i, '$1'],
		[/(matr)ices$/i, '$1ix'],
		[/(vert|ind)ices$/i, '$1ex'],
		[/^(ox)en/i, '$1'],
		[/(alias|status)es$/i, '$1'],
		[/(octop|vir)i$/i, '$1us'],
		[/(cris|ax|test)es$/i, '$1is'],
		[/(shoe)s$/i, '$1'],
		[/(o)es$/i, '$1'],
		[/(bus)es$/i, '$1'],
		[/([m|l])ice$/i, '$1ouse'],
		[/(x|ch|ss|sh)es$/i, '$1'],
		[/(m)ovies$/i, '$1ovie'],
		[/(s)eries$/i, '$1eries'],
		[/([^aeiouy]|qu)ies$/i, '$1y'],
		[/([lr])ves$/i, '$1f'],
		[/(tive)s$/i, '$1'],
		[/(hive)s$/i, '$1'],
		[/([^f])ves$/i, '$1fe'],
		[/(^analy)ses$/i, '$1sis'],
		[/((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$/i, '$1$2sis'],
		[/([ti])a$/i, '$1um'],
		[/(n)ews$/i, '$1ews'],
		[/s$/i, '']
	];
	
	/**
	 *	A list of words that do not change when made plural.
	 */
	static public var uncountables:Array = [
		"equipment", "information", "rice", "money", "species", "series", "fish", "sheep"
	];


	//-------------------------------------------------------------------------
	//
	//  Static methods
	//
	//-------------------------------------------------------------------------

	/**
	 *	Converts a string to camel case.
	 *	
	 *	@param str  The string to convert to camel case.
	 *	
	 *	@return     A camel-case formatted string.
	 */
	static public function camelize(str:String, initialCap:Boolean=true):String
	{
		// Return null or blank strings
		if(str == null || str == "") {
			return str;
		}

		// Convert underscores to spaces & trim
		str = str.replace(/_/g, " ");
		str = str.replace(/^ +| +$/g, "");
		
		// Replace words with initial case
		str = str.replace(/(\w)(\w*)/g,
			function(match:String, $0:String, $1:String, index:int, string:String):String{
				// If we are not doing initial caps and we're at index 0
				// then return the match as is.
				if(!initialCap && index == 0) {
					return match.toLowerCase();
				}
				// If we are doing initial caps or we are past the beginning,
				// then upper case the first letter
				else {
					return $0.toUpperCase() + ($1 ? $1 : "");
				}
			}
		);
		
		// Remove spaces entirely
		return str.replace(/ +/g, "")
	}


	/**
	 *	Converts a string to a class name. This returns a string and not a
	 *	reference to the actual class. This is the same as
	 *	<code>camelize()</code> except that it is always returned in the
	 *	singular.
	 *	
	 *	@param str  The string to convert to a class name.
	 *	
	 *	@return     A class name formatted string.
	 */
	/*
	static public function classify(str:String):String
	{
		return singularize(camelize(str));
	}
	*/


	/**
	 *	Converts the underscores and spaces in a string to dashes.
	 *	
	 *	@param str  The string to convert.
	 *	
	 *	@return     A dasherized string.
	 */
	static public function dasherize(str:String):String
	{
		// Return null or blank strings
		if(str == null || str == "") {
			return str;
		}

		// Trim & convert underscores and spaces to dashes
		str = str.replace(/^ +| +$/g, "");
		str = str.replace(/_+/g, "-");
		
		return str;
	}


	/**
	 *	Converts a string to a human readable format. It strips the underscores
	 *	and it converts the words to lowercase except for the first word.
	 *	
	 *	@param str  The string to convert.
	 *	
	 *	@return     A human readable string.
	 */
	static public function humanize(str:String):String
	{
		// Return null or blank strings
		if(str == null || str == "") {
			return str;
		}

		// Convert underscores to spaces, add spaces between words
		str = str.replace(/_/g, " ");
		str = str.replace(/(?<=[a-zA-Z])([A-Z0-9])/g, " $1");
		
		// Lower case everything except first letter
		str = str.toLowerCase();
		str = str.replace(/\w/, function():String{return arguments[0].toUpperCase()});
		
		// Trim
		str = str.replace(/^ +| +$/g, "");
		
		return str;
	}

	/**
	 *	Converts a string from a singular to its plural form.
	 *	
	 *	@param str  The singluar string to convert.
	 *	
	 *	@return     A pluralized string.
	 */
	static public function pluralize(str:String):String
	{
		// Return null or blank strings
		if(str == null || str == "") {
			return str;
		}

		// If it is uncountable, return it as is
		if(uncountables.indexOf(str.toLowerCase()) != -1) {
			return str;
		}
		
		// Loop over plural rules to determine how to pluralize
		for each(var rule:Array in plurals) {
			if(str.search(rule[0]) != -1) {
				return str.replace(rule[0], rule[1]);
			}
		}
		
		// If no match is found, return as is
		return str;
	}

	/**
	 *	Converts a string from a plural to its singular form.
	 *	
	 *	@param str  The plural string to convert.
	 *	
	 *	@return     A singular string.
	 */
	static public function singularize(str:String):String
	{
		// Return null or blank strings
		if(str == null || str == "") {
			return str;
		}

		// If it is uncountable, return it as is
		if(uncountables.indexOf(str.toLowerCase()) != -1) {
			return str;
		}
		
		// Loop over singular rules to determine how to singularize
		for each(var rule:Array in singulars) {
			if(str.search(rule[0]) != -1) {
				return str.replace(rule[0], rule[1]);
			}
		}
		
		// If no match is found, return as is
		return str;
	}

	/**
	 *	Converts a string to lowercase and underscored.
	 *	
	 *	@param str  The string to convert.
	 *	
	 *	@return     A lowercase, underscored string.
	 */
	static public function underscore(str:String):String
	{
		// Return null or blank strings
		if(str == null || str == "") {
			return str;
		}

		// Convert dashes to underscores
		str = str.replace(/([A-Z]+)([A-Z][a-z])/g, "$1_$2");
		str = str.replace(/([a-z\d])([A-Z])/g, "$1_$2");
		str = str.replace(/-+/g, "_");
		str = str.toLowerCase();
		
		return str;
	}

	//-------------------------------------------------------------------------
	//
	//  Constructor
	//
	//-------------------------------------------------------------------------

	/**
	 *  Constructor.
	 */
	public function Inflector()
	{
		throw new IllegalOperationError("Cannot instantiate Inflector");
	}
}
}
