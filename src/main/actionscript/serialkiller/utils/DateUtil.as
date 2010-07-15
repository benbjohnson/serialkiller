package serialkiller.utils
{
/**
 *  This class provides utility methods for working with dates.
 */
public class DateUtil
{
	//-------------------------------------------------------------------------
	//
	//  Static methods
	//
	//-------------------------------------------------------------------------

	/**
	 *	Formats a date in YYYY-MM-DD format.
	 *	
	 *	@param date  The date to format.
	 *	
	 *	@return      The formatted date string.
	 */
	static public function formatDate(date:Date):String
	{
		if(date) {
			return date.fullYearUTC + "-" +
				   (date.monthUTC < 9 ? "0" : "") + (date.monthUTC+1) + "-" +
				   (date.dateUTC < 10 ? "0" : "") + date.dateUTC;
		}
		else {
			return "";
		}
	}

	/**
	 *	Formats a date in YYYY-MM-DD format.
	 *	
	 *	@param date  The date to format.
	 *	
	 *	@return      The formatted datetime string.
	 */
	static public function formatDateTime(date:Date):String
	{
		if(date) {
			return date.fullYearUTC + "-" +
				   (date.monthUTC < 9 ? "0" : "") + (date.monthUTC+1) + "-" +
				   (date.dateUTC < 10 ? "0" : "") + date.dateUTC + "T" +
				   (date.hoursUTC < 10 ? "0" : "") + date.hoursUTC + ":" +
				   (date.minutesUTC < 10 ? "0" : "") + date.minutesUTC + ":" +
				   (date.secondsUTC < 10 ? "0" : "") + date.secondsUTC + "Z";
		}
		else {
			return "";
		}
	}


	/**
	 *	Parses a date in YYYY-MM-DD format.
	 *	
	 *	@param date  The date string to parse.
	 *	
	 *	@return      A date object.
	 */
	static public function parseDate(str:String):Date
	{
		if(!str) return null;
		
		var match:Array = str.match(/^(\d+)-(\d+)-(\d+)$/);
		if(match) {
			return new Date(parseInt(match[1]), parseInt(match[2])-1, parseInt(match[3]));
		}
		else {
			return null;
		}
	}

	/**
	 *	Parses a date in YYYY-MM-DDTHH:MM:SSZ format.
	 *	
	 *	@param date  The date string to parse.
	 *	
	 *	@return      A date object.
	 */
	static public function parseDateTime(str:String):Date
	{
		if(!str) return null;
		
		var match:Array = str.match(/^(\d+)-(\d+)-(\d+)T(\d+):(\d+):(\d+)Z$/);
		if(match) {
			var date:Date = new Date();
			date.fullYearUTC = parseInt(match[1]);
			date.monthUTC = parseInt(match[2])-1;
			date.dateUTC = parseInt(match[3]);
			date.hoursUTC = parseInt(match[4]);
			date.minutesUTC = parseInt(match[5]);
			date.secondsUTC = parseInt(match[6]);
			date.millisecondsUTC = 0;
			return date;
		}
		else {
			return null;
		}
	}
}
}