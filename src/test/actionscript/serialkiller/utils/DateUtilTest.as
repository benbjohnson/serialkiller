package serialkiller.utils
{
import org.flexunit.Assert;

public class DateUtilTest
{
	//-------------------------------------------------------------------------
	//
	//  Static methods
	//
	//-------------------------------------------------------------------------

	//---------------------------------
	//  Date formatting
	//---------------------------------
	
	[Test]
	public function dateShouldFormatWithPadding():void
	{
		Assert.assertEquals("2010-09-09", DateUtil.formatDate(new Date(2010, 8, 9)));
	}
	
	[Test]
	public function dateShouldFormatWithoutPadding():void
	{
		Assert.assertEquals("2010-10-10", DateUtil.formatDate(new Date(2010, 9, 10)));
	}
	
	[Test]
	public function dateFormatShouldReturnEmptyStringForNull():void
	{
		Assert.assertEquals("", DateUtil.formatDate(null));
	}


	//---------------------------------
	//  Datetime formatting
	//---------------------------------
	
	[Test]
	public function dateTimeShouldFormatWithPadding():void
	{
		var date:Date = new Date(2010, 8, 9);
		date.hoursUTC   = 9;
		date.minutesUTC = 9;
		date.secondsUTC = 9;
		Assert.assertEquals("2010-09-09T09:09:09Z", DateUtil.formatDateTime(date));
	}
	
	[Test]
	public function dateTimeShouldFormatWithoutPadding():void
	{
		var date:Date = new Date(2010, 9, 10);
		date.hoursUTC   = 10;
		date.minutesUTC = 10;
		date.secondsUTC = 10;
		Assert.assertEquals("2010-10-10T10:10:10Z", DateUtil.formatDateTime(date));
	}
	
	[Test]
	public function dateTimeFormatShouldReturnEmptyStringForNull():void
	{
		Assert.assertEquals("", DateUtil.formatDateTime(null));
	}


	//---------------------------------
	//  Date parsing
	//---------------------------------
	
	[Test]
	public function shouldParseDate():void
	{
		var date:Date = DateUtil.parseDate("2010-10-10");
		Assert.assertEquals(2010, date.fullYearUTC);
		Assert.assertEquals(9, date.monthUTC);
		Assert.assertEquals(10, date.dateUTC);
	}
	
	[Test]
	public function shouldParseNullDateStringAsNull():void
	{
		Assert.assertNull(DateUtil.parseDate(null));
	}
	
	[Test]
	public function shouldParseInvalidDateStringAsNull():void
	{
		Assert.assertNull(DateUtil.parseDate("foo"));
	}
	
	[Test]
	public function shouldParseDateTime():void
	{
		var date:Date = DateUtil.parseDateTime("2010-06-04T10:11:12Z");
		Assert.assertEquals(2010, date.fullYearUTC);
		Assert.assertEquals(5, date.monthUTC);
		Assert.assertEquals(4, date.dateUTC);
		Assert.assertEquals(10, date.hoursUTC);
		Assert.assertEquals(11, date.minutesUTC);
		Assert.assertEquals(12, date.secondsUTC);
	}
	
	[Test]
	public function shouldParseNullDateTimeStringAsNull():void
	{
		Assert.assertNull(DateUtil.parseDateTime(null));
	}
	
	[Test]
	public function shouldParseInvalidDateTimeStringAsNull():void
	{
		Assert.assertNull(DateUtil.parseDateTime("foo"));
	}
}
}