package serialkiller.core
{
import org.flexunit.Assert;

public class InflectorTest
{
	//-----------------------------
	//  Setup
	//-----------------------------

	[Before]
	public function setUp():void
	{
	}
	

	//-------------------------------------------------------------------------
	//
	//	Static methods
	//
	//-------------------------------------------------------------------------

	//-----------------------------
	//  camelize()
	//-----------------------------

	[Test]
	public function camelize():void
	{
		Assert.assertEquals("SerialKiller", Inflector.camelize("serial killer"));
	}

	[Test]
	public function camelize_initialLowerCaps():void
	{
		Assert.assertEquals("adobeFlex", Inflector.camelize("Adobe Flex", false));
	}

	[Test]
	public function camelize_untrimmed():void
	{
		Assert.assertEquals("AdobeFlex", Inflector.camelize("  Adobe Flex  "));
	}

	[Test]
	public function camelize_withPunctuation():void
	{
		Assert.assertEquals("ThisIsATEST!", Inflector.camelize("this_is a TEST!"));
	}

	[Test]
	public function camelize_null():void
	{
		Assert.assertNull(Inflector.camelize(null));
	}

	[Test]
	public function camelize_blank():void
	{
		Assert.assertEquals("", Inflector.camelize(""));
	}

	
	//-----------------------------
	//  dasherize()
	//-----------------------------

	[Test]
	public function dasherize():void
	{
		Assert.assertEquals("this-is-cool", Inflector.dasherize("this_is__cool"));
	}

	[Test]
	public function dasherize_null():void
	{
		Assert.assertNull(Inflector.dasherize(null));
	}

	[Test]
	public function dasherize_blank():void
	{
		Assert.assertEquals("", Inflector.dasherize(""));
	}

	
	//-----------------------------
	//  humanize()
	//-----------------------------

	[Test]
	public function humanize():void
	{
		Assert.assertEquals("This is awesome!", Inflector.humanize("this_is_awesome!"));
	}

	[Test]
	public function humanize_untrimmed():void
	{
		Assert.assertEquals("Hello and welcome", Inflector.humanize("  hello and welcome  "));
	}

	[Test]
	public function humanize_null():void
	{
		Assert.assertNull(Inflector.humanize(null));
	}

	[Test]
	public function humanize_blank():void
	{
		Assert.assertEquals("", Inflector.humanize(""));
	}

	
	//-----------------------------
	//  pluralize()
	//-----------------------------

	[Test]
	public function pluralize_0():void
	{
		Assert.assertEquals("people", Inflector.pluralize("person"));
		Assert.assertEquals("People", Inflector.pluralize("Person"));
	}

	[Test]
	public function pluralize_1():void
	{
		Assert.assertEquals("men", Inflector.pluralize("man"));
		Assert.assertEquals("Men", Inflector.pluralize("Man"));
	}

	[Test]
	public function pluralize_2():void
	{
		Assert.assertEquals("children", Inflector.pluralize("child"));
		Assert.assertEquals("Children", Inflector.pluralize("Child"));
	}

	[Test]
	public function pluralize_3():void
	{
		Assert.assertEquals("sexes", Inflector.pluralize("sex"));
		Assert.assertEquals("Sexes", Inflector.pluralize("Sex"));
	}

	[Test]
	public function pluralize_4():void
	{
		Assert.assertEquals("moves", Inflector.pluralize("move"));
		Assert.assertEquals("Moves", Inflector.pluralize("Move"));
	}

	[Test]
	public function pluralize_5():void
	{
		Assert.assertEquals("quizzes", Inflector.pluralize("quiz"));
		Assert.assertEquals("Quizzes", Inflector.pluralize("Quiz"));
	}
	
	[Test]
	public function pluralize_6():void
	{
		Assert.assertEquals("oxen", Inflector.pluralize("ox"));
		Assert.assertEquals("Oxen", Inflector.pluralize("Ox"));
	}
	
	[Test]
	public function pluralize_7():void
	{
		Assert.assertEquals("mice", Inflector.pluralize("mouse"));
		Assert.assertEquals("Mice", Inflector.pluralize("Mouse"));
	}
	
	[Test]
	public function pluralize_8():void
	{
		Assert.assertEquals("matrices", Inflector.pluralize("matrix"));
		Assert.assertEquals("Vertices", Inflector.pluralize("Vertex"));
	}
	
	[Test]
	public function pluralize_9():void
	{
		Assert.assertEquals("axes", Inflector.pluralize("ax"));
		Assert.assertEquals("Touches", Inflector.pluralize("Touch"));
	}
	
	[Test]
	public function pluralize_10():void
	{
		Assert.assertEquals("flies", Inflector.pluralize("fly"));
	}
	
	[Test]
	public function pluralize_11():void
	{
		Assert.assertEquals("hives", Inflector.pluralize("hive"));
		Assert.assertEquals("Hives", Inflector.pluralize("Hive"));
	}
	
	[Test]
	public function pluralize_12():void
	{
		Assert.assertEquals("calves", Inflector.pluralize("calf"));
		Assert.assertEquals("wives", Inflector.pluralize("wife"));
	}
	
	[Test]
	public function pluralize_13():void
	{
		Assert.assertEquals("analyses", Inflector.pluralize("analysis"));
		Assert.assertEquals("Antitheses", Inflector.pluralize("Antithesis"));
	}
	
	[Test]
	public function pluralize_14():void
	{
		Assert.assertEquals("tomatoes", Inflector.pluralize("tomato"));
		Assert.assertEquals("Buffaloes", Inflector.pluralize("Buffalo"));
	}
	
	[Test]
	public function pluralize_15():void
	{
		Assert.assertEquals("buses", Inflector.pluralize("bus"));
		Assert.assertEquals("Buses", Inflector.pluralize("Bus"));
	}
	
	[Test]
	public function pluralize_16():void
	{
		Assert.assertEquals("aliases", Inflector.pluralize("alias"));
		Assert.assertEquals("Statuses", Inflector.pluralize("Status"));
	}
	
	[Test]
	public function pluralize_17():void
	{
		Assert.assertEquals("octopi", Inflector.pluralize("octopus"));
		Assert.assertEquals("Cacti", Inflector.pluralize("Cactus"));
	}
	
	[Test]
	public function pluralize_18():void
	{
		Assert.assertEquals("axes", Inflector.pluralize("axis"));
		Assert.assertEquals("Axes", Inflector.pluralize("Axis"));
	}
	
	[Test]
	public function pluralize_19():void
	{
		Assert.assertEquals("mumps", Inflector.pluralize("mumps"));
		Assert.assertEquals("Mumps", Inflector.pluralize("Mumps"));
	}
	
	[Test]
	public function pluralize_20():void
	{
		Assert.assertEquals("sticks", Inflector.pluralize("stick"));
		Assert.assertEquals("Dogs", Inflector.pluralize("Dog"));
	}
	

	//-----------------------------
	//  singularize()
	//-----------------------------

	[Test]
	public function singularize_0():void
	{
		Assert.assertEquals("person", Inflector.singularize("person"));
		Assert.assertEquals("Person", Inflector.singularize("People"));
	}
	
	[Test]
	public function singularize_1():void
	{
		Assert.assertEquals("man", Inflector.singularize("men"));
		Assert.assertEquals("Man", Inflector.singularize("Men"));
	}
	
	[Test]
	public function singularize_2():void
	{
		Assert.assertEquals("child", Inflector.singularize("children"));
		Assert.assertEquals("Child", Inflector.singularize("Children"));
	}
	
	[Test]
	public function singularize_3():void
	{
		Assert.assertEquals("sex", Inflector.singularize("sexes"));
		Assert.assertEquals("Sex", Inflector.singularize("Sexes"));
	}
	
	[Test]
	public function singularize_4():void
	{
		Assert.assertEquals("move", Inflector.singularize("moves"));
		Assert.assertEquals("Move", Inflector.singularize("Moves"));
	}
	
	[Test]
	public function singularize_5():void
	{
		Assert.assertEquals("database", Inflector.singularize("databases"));
		Assert.assertEquals("Database", Inflector.singularize("Databases"));
	}
	
	[Test]
	public function singularize_6():void
	{
		Assert.assertEquals("quiz", Inflector.singularize("quizzes"));
		Assert.assertEquals("Quiz", Inflector.singularize("Quizzes"));
	}
	
	[Test]
	public function singularize_7():void
	{
		Assert.assertEquals("matrix", Inflector.singularize("matrices"));
		Assert.assertEquals("Matrix", Inflector.singularize("Matrices"));
	}
	
	[Test]
	public function singularize_8():void
	{
		Assert.assertEquals("vertex", Inflector.singularize("vertices"));
		Assert.assertEquals("Index", Inflector.singularize("Indices"));
	}
	
	[Test]
	public function singularize_9():void
	{
		Assert.assertEquals("ox", Inflector.singularize("oxen"));
		Assert.assertEquals("Ox", Inflector.singularize("Oxen"));
	}
	
	[Test]
	public function singularize_10():void
	{
		Assert.assertEquals("status", Inflector.singularize("statuses"));
		Assert.assertEquals("Alias", Inflector.singularize("Aliases"));
	}
	
	[Test]
	public function singularize_11():void
	{
		Assert.assertEquals("octopus", Inflector.singularize("octopi"));
		Assert.assertEquals("Virus", Inflector.singularize("Viri"));
	}
	
	[Test]
	public function singularize_12():void
	{
		Assert.assertEquals("crisis", Inflector.singularize("crises"));
		Assert.assertEquals("Axis", Inflector.singularize("Axes"));
	}
	
	[Test]
	public function singularize_13():void
	{
		Assert.assertEquals("shoe", Inflector.singularize("shoes"));
		Assert.assertEquals("Shoe", Inflector.singularize("Shoes"));
	}
	
	[Test]
	public function singularize_14():void
	{
		Assert.assertEquals("ho", Inflector.singularize("hoes"));
		Assert.assertEquals("Ho", Inflector.singularize("Hoes"));
	}
	
	[Test]
	public function singularize_15():void
	{
		Assert.assertEquals("bus", Inflector.singularize("buses"));
		Assert.assertEquals("Bus", Inflector.singularize("Buses"));
	}
	
	[Test]
	public function singularize_16():void
	{
		Assert.assertEquals("mouse", Inflector.singularize("mice"));
		Assert.assertEquals("Mouse", Inflector.singularize("Mice"));
	}
	
	[Test]
	public function singularize_17():void
	{
		Assert.assertEquals("business", Inflector.singularize("businesses"));
		Assert.assertEquals("Dish", Inflector.singularize("Dishes"));
	}
	
	[Test]
	public function singularize_18():void
	{
		Assert.assertEquals("movie", Inflector.singularize("movies"));
		Assert.assertEquals("Movie", Inflector.singularize("Movies"));
	}
	
	[Test]
	public function singularize_19():void
	{
		Assert.assertEquals("series", Inflector.singularize("series"));
		Assert.assertEquals("Series", Inflector.singularize("Series"));
	}
	
	[Test]
	public function singularize_20():void
	{
		Assert.assertEquals("fly", Inflector.singularize("flies"));
		Assert.assertEquals("Fly", Inflector.singularize("Flies"));
	}
	
	[Test]
	public function singularize_21():void
	{
		Assert.assertEquals("calf", Inflector.singularize("calves"));
		Assert.assertEquals("Half", Inflector.singularize("Halves"));
	}
	
	[Test]
	public function singularize_22():void
	{
		Assert.assertEquals("creative", Inflector.singularize("creatives"));
		Assert.assertEquals("Creative", Inflector.singularize("Creatives"));
	}
	
	[Test]
	public function singularize_23():void
	{
		Assert.assertEquals("hive", Inflector.singularize("hives"));
		Assert.assertEquals("Hive", Inflector.singularize("Hives"));
	}
	
	[Test]
	public function singularize_24():void
	{
		Assert.assertEquals("analysis", Inflector.singularize("analyses"));
		Assert.assertEquals("Analysis", Inflector.singularize("Analyses"));
	}
	
	[Test]
	public function singularize_25():void
	{
		Assert.assertEquals("thesis", Inflector.singularize("theses"));
		Assert.assertEquals("Synopsis", Inflector.singularize("Synopses"));
	}
	
	[Test]
	public function singularize_26():void
	{
		Assert.assertEquals("news", Inflector.singularize("news"));
		Assert.assertEquals("News", Inflector.singularize("News"));
	}
	
	[Test]
	public function singularize_27():void
	{
		Assert.assertEquals("stick", Inflector.singularize("sticks"));
		Assert.assertEquals("Dog", Inflector.singularize("Dogs"));
	}
	


	//-----------------------------
	//  underscore()
	//-----------------------------
	
	[Test]
	public function underscore():void
	{
		Assert.assertEquals("leafed_box_is super_cool", Inflector.underscore("LeafedBox_is super_Cool"));
	}
	
	[Test]
	public function underscore_null():void
	{
		Assert.assertNull(Inflector.underscore(null));
	}
	
	[Test]
	public function underscore_blank():void
	{
		Assert.assertEquals("", Inflector.underscore(""));
	}


	//-----------------------------
	//  Tear down
	//-----------------------------

	[After]
	public function tearDown():void
	{
	}
}
}