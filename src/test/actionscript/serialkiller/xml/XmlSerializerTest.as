package serialkiller.xml
{
import serialkiller.core.Type;
import serialkiller.test.*;

import org.flexunit.Assert;
import org.flexunit.async.Async;

import flash.utils.describeType;

public class XmlSerializerTest
{
	private var serializer:XmlSerializer;
	private var topic:Topic;
	
	[Embed(source='data/topic.xml', mimeType='application/octet-stream')]
	private var asset_xml:Class;
	
	//---------------------------------
	//  Setup
	//---------------------------------
	
	[Before]
	public function setUp():void
	{
		serializer = new XmlSerializer();
		Type.classPath = ["serialkiller.test"];

		topic = new Topic();
	}


	//-------------------------------------------------------------------------
	//
	//  Methods
	//
	//-------------------------------------------------------------------------

	//---------------------------------
	//  toXml()
	//---------------------------------
	
	[Test]
	public function toXml_localName():void
	{
		var xml:XML = serializer.toXml(topic);
		Assert.assertEquals("topic", xml.name().localName);
	}

	[Test]
	public function toXml_string():void
	{
		topic.title = "The First Topic";
		var xml:XML = serializer.toXml(topic);
		Assert.assertEquals("The First Topic", xml.title);
	}

	[Test]
	public function toXml_blankString():void
	{
		topic.authorEmailAddress = "";
		var xml:XML = serializer.toXml(topic);
		Assert.assertEquals("", xml['author-email-address']);
	}

	[Test]
	public function toXml_nullString():void
	{
		topic.content = null;
		var xml:XML = serializer.toXml(topic);
		Assert.assertEquals("", xml.content);
		Assert.assertEquals("true", xml.content.@nil);
	}

	[Test]
	public function toXml_number_integer():void
	{
		topic.id = 1;
		var xml:XML = serializer.toXml(topic);
		Assert.assertEquals("1", xml.id);
		Assert.assertEquals("integer", xml.id.@type);
	}

	[Test]
	public function toXml_number_integerNaN():void
	{
		topic.id = NaN;
		var xml:XML = serializer.toXml(topic);
		Assert.assertEquals("", xml.id);
		Assert.assertEquals("integer", xml.id.@type);
		Assert.assertEquals("true", xml.id.@nil);
	}

	[Test]
	public function toXml_number_float():void
	{
		topic.temperature = 56.283829;
		var xml:XML = serializer.toXml(topic);
		Assert.assertEquals("56.283829", xml.temperature);
		Assert.assertEquals("float", xml.temperature.@type);
	}

	[Test]
	public function toXml_number_floatNaN():void
	{
		topic.temperature = NaN;
		var xml:XML = serializer.toXml(topic);
		Assert.assertEquals("", xml.temperature);
		Assert.assertEquals("float", xml.temperature.@type);
		Assert.assertEquals("true", xml.temperature.@nil);
	}

	[Test]
	public function toXml_number_decimal():void
	{
		topic.salary = 53392.23;
		var xml:XML = serializer.toXml(topic);
		Assert.assertEquals("53392.23", xml.salary);
		Assert.assertEquals("decimal", xml.salary.@type);
	}

	[Test]
	public function toXml_number_decimalNaN():void
	{
		topic.salary = NaN;
		var xml:XML = serializer.toXml(topic);
		Assert.assertEquals("", xml.salary);
		Assert.assertEquals("decimal", xml.salary.@type);
		Assert.assertEquals("true", xml.salary.@nil);
	}

	[Test]
	public function toXml_integer():void
	{
		topic.id2 = 1;
		var xml:XML = serializer.toXml(topic);
		Assert.assertEquals("1", xml.id2);
		Assert.assertEquals("integer", xml.id2.@type);
	}
	
	[Test]
	public function toXml_boolean():void
	{
		topic.approved = true;
		var xml:XML = serializer.toXml(topic);
		Assert.assertEquals("true", xml.approved);
		Assert.assertEquals("boolean", xml.approved.@type);
	}
	
	[Test]
	public function toXml_date():void
	{
		topic.lastRead = new Date(2003, 4, 2);
		var xml:XML = serializer.toXml(topic);
		Assert.assertEquals("2003-05-02", xml['last-read']);
		Assert.assertEquals("date", xml['last-read'].@type);
	}
	
	[Test]
	public function toXml_date_null():void
	{
		topic.lastRead = null;
		var xml:XML = serializer.toXml(topic);
		Assert.assertEquals("", xml['last-read']);
		Assert.assertEquals("date", xml['last-read'].@type);
		Assert.assertEquals("true", xml['last-read'].@nil);
	}
	
	[Test]
	public function toXml_datetime():void
	{
		var value:Date = new Date(1998, 4, 13, 6, 12, 34);
		topic.writtenOn = value;

		var xml:XML = serializer.toXml(topic);
		
		// NOTE: This is ugly so that it will compile on all computers
		//       regardless of timezone.
		var str:String = xml['written-on'];
		str = str.replace(/0/g, "");
		
		Assert.assertEquals("1998-5-" + value.dateUTC + "T" + value.hoursUTC + ":" + value.minutesUTC + ":" + value.secondsUTC + "Z", str);
		Assert.assertEquals("datetime", xml['written-on'].@type);
	}
	
	[Test]
	public function toXml_datetime_null():void
	{
		topic.writtenOn = null;
		var xml:XML = serializer.toXml(topic);
		Assert.assertEquals("", xml['written-on']);
		Assert.assertEquals("datetime", xml['written-on'].@type);
		Assert.assertEquals("true", xml['written-on'].@nil);
	}
	
	[Test]
	public function toXml_object():void
	{
		topic.title = "Child Topic";
		topic.parentTopic = new Topic();
		topic.parentTopic.title = "Parent Topic";
		
		var xml:XML = serializer.toXml(topic, {inc:{parentTopic:{}}});
		Assert.assertEquals("Child Topic", xml.title);
		Assert.assertEquals("Parent Topic", xml['parent-topic'].title);
	}
	
	[Test]
	public function toXml_object_null():void
	{
		topic.parentTopic = null;
		var xml:XML = serializer.toXml(topic, {inc:{parentTopic:{}}});
		Assert.assertEquals("true", xml['parent-topic'].@nil);
	}
	
	[Test]
	public function toXml_array():void
	{
		topic.subTopics = new Array();
		topic.subTopics[0] = new Topic();
		topic.subTopics[0].title = "Topic 0";
		topic.subTopics[1] = new Topic();
		topic.subTopics[1].title = "Topic 1";
		
		var xml:XML = serializer.toXml(topic, {inc:{subTopics:{}}});
		Assert.assertEquals("Topic 0", xml['sub-topics'].topic[0].title);
		Assert.assertEquals("Topic 1", xml['sub-topics'].topic[1].title);
	}
	
	[Test]
	public function toXml_array_null():void
	{
		topic.subTopics = null;
		var xml:XML = serializer.toXml(topic, {inc:{subTopics:{}}});
		Assert.assertEquals("true", xml['sub-topics'].@nil);
	}
	
	[Test]
	public function toXml_only():void
	{
		topic.title = "The First Topic";
		topic.content = "Hello today";
		var xml:XML = serializer.toXml(topic, {only:["title"]});
		Assert.assertEquals("The First Topic", xml.title);
		Assert.assertEquals(0, xml.content.length());
	}

	[Test]
	public function toXml_only_nested():void
	{
		topic.title = "The First Topic";
		topic.content = "Hello today";
		topic.parentTopic = new Topic();
		topic.parentTopic.title = "The Parent Topic";
		topic.parentTopic.content = "Goodbye tomorrow";
		
		var xml:XML = serializer.toXml(topic, {only:["content"], inc:{parentTopic:{only:["title"]}}});
		Assert.assertEquals(0, xml.title.length());
		Assert.assertEquals("Hello today", xml.content);
		Assert.assertEquals("The Parent Topic", xml['parent-topic'].title);
		Assert.assertEquals(0, xml['parent-topic'].content.length());
	}
	
	[Test]
	public function toXml_except():void
	{
		topic.title = "The First Topic";
		topic.content = "Hello today";
		topic.salary = 102.34;
		var xml:XML = serializer.toXml(topic, {except:["title"]});
		Assert.assertEquals(0, xml.title.length());
		Assert.assertEquals("Hello today", xml.content);
		Assert.assertEquals("102.34", xml.salary);
	}

	[Test]
	public function toXml_except_nested():void
	{
		topic.title = "The First Topic";
		topic.content = "Hello today";
		topic.parentTopic = new Topic();
		topic.parentTopic.title = "The Parent Topic";
		topic.parentTopic.content = "Goodbye tomorrow";
		
		var xml:XML = serializer.toXml(topic, {except:["title"], inc:{parentTopic:{except:["content"]}}});
		Assert.assertEquals(0, xml.title.length());
		Assert.assertEquals("Hello today", xml.content);
		Assert.assertEquals("The Parent Topic", xml['parent-topic'].title);
		Assert.assertEquals(0, xml['parent-topic'].content.length());
	}

	[Test]
	public function toXml_inc():void
	{
		topic.title = "The First Topic";
		topic.parentTopic = new Topic();
		topic.parentTopic.title = "The Parent Topic";
		topic.parentTopic.parentTopic = new Topic();
		topic.parentTopic.parentTopic.title = "The Parent Parent Topic";
		
		var xml:XML = serializer.toXml(topic, {inc:{parentTopic:{inc:{parentTopic:{}}}}});
		Assert.assertEquals("The First Topic", xml.title);
		Assert.assertEquals("The Parent Topic", xml['parent-topic'].title);
		Assert.assertEquals("The Parent Parent Topic", xml['parent-topic']['parent-topic'].title);
	}
	
	[Test]
	public function toXml_rootArray():void
	{
		var topics:Array = new Array();
		topics[0] = new Topic();
		topics[0].title = "Topic 0";
		topics[1] = new Topic();
		topics[1].title = "Topic 1";
		
		var xml:XML = serializer.toXml(topics);
		Assert.assertEquals("Topic 0", xml.topic[0].title);
		Assert.assertEquals("Topic 1", xml.topic[1].title);
	}
	

	//---------------------------------
	//  toXml()
	//---------------------------------
	
	[Test]
	public function fromXml_type():void
	{
		var xml:XML = <topic/>;
		var data:Object = serializer.fromXml(xml);
		Assert.assertTrue(data is Topic);
	}
	
	[Test]
	public function fromXml_string():void
	{
		var xml:XML = <topic><title>My Topic</title></topic>;
		topic = serializer.fromXml(xml);
		Assert.assertEquals("My Topic", topic.title);
	}
	
	[Test]
	public function fromXml_string_blank():void
	{
		var xml:XML = <topic><title></title></topic>;
		topic = serializer.fromXml(xml);
		Assert.assertEquals("", topic.title);
	}
	
	[Test]
	public function fromXml_string_null():void
	{
		var xml:XML = <topic><title nil="true"></title></topic>;
		topic = serializer.fromXml(xml);
		Assert.assertNull(topic.title);
	}
	
	[Test]
	public function fromXml_number_float():void
	{
		var xml:XML = <topic><temperature type="float">283.21224</temperature></topic>;
		topic = serializer.fromXml(xml);
		Assert.assertEquals(283.21224, topic.temperature);
	}
	
	[Test]
	public function fromXml_number_integer():void
	{
		var xml:XML = <topic><id type="integer">3</id></topic>;
		topic = serializer.fromXml(xml);
		Assert.assertEquals(3, topic.id);
	}
	
	[Test]
	public function fromXml_number_decimal():void
	{
		var xml:XML = <topic><salary type="decimal">102.34</salary></topic>;
		topic = serializer.fromXml(xml);
		Assert.assertEquals(102.34, topic.salary);
	}
	
	[Test]
	public function fromXml_number_null():void
	{
		var xml:XML = <topic><temperature nil="true"></temperature></topic>;
		topic = serializer.fromXml(xml);
		Assert.assertTrue(isNaN(topic.temperature));
	}
	
	[Test]
	public function fromXml_number_integerNull():void
	{
		var xml:XML = <topic><id2 nil="true"></id2></topic>;
		topic = serializer.fromXml(xml);
		Assert.assertEquals(0, topic.id2);
	}

	[Test]
	public function fromXml_boolean():void
	{
		var xml:XML = <topic><approved type="boolean">true</approved></topic>;
		topic = serializer.fromXml(xml);
		Assert.assertTrue(topic.approved);
	}

	[Test]
	public function fromXml_boolean_null():void
	{
		var xml:XML = <topic><approved type="boolean" nil="true"/></topic>;
		topic = serializer.fromXml(xml);
		Assert.assertFalse(topic.approved);
	}

	[Test]
	public function fromXml_date():void
	{
		var xml:XML = <topic><last-read type="date">2003-04-05</last-read></topic>;
		topic = serializer.fromXml(xml);
		Assert.assertEquals(2003, topic.lastRead.fullYear);
		Assert.assertEquals(3, topic.lastRead.month);
		Assert.assertEquals(5, topic.lastRead.date);
	}

	[Test]
	public function fromXml_date_null():void
	{
		var xml:XML = <topic><last-read type="date" nil="true"/></topic>;
		topic = serializer.fromXml(xml);
		Assert.assertNull(topic.lastRead);
	}

	[Test]
	public function fromXml_datetime():void
	{
		var xml:XML = <topic><written-on type="datetime">2003-04-05T08:32:24Z</written-on></topic>;
		topic = serializer.fromXml(xml);
		Assert.assertEquals(2003, topic.writtenOn.fullYearUTC);
		Assert.assertEquals(3, topic.writtenOn.monthUTC);
		Assert.assertEquals(5, topic.writtenOn.dateUTC);
		Assert.assertEquals(8, topic.writtenOn.hoursUTC);
		Assert.assertEquals(32, topic.writtenOn.minutesUTC);
		Assert.assertEquals(24, topic.writtenOn.secondsUTC);
	}

	[Test]
	public function fromXml_datetime_null():void
	{
		var xml:XML = <topic><written-on type="datetime" nil="true"/></topic>;
		topic = serializer.fromXml(xml);
		Assert.assertNull(topic.writtenOn);
	}

	[Test]
	public function fromXml_array():void
	{
		var xml:XML =
			<topic>
				<sub-topics type="array">
					<topic>
						<title>Sub Topic 1</title>
					</topic>
					<topic>
						<title>Sub Topic 2</title>
					</topic>
				</sub-topics>
			</topic>;
			
		topic = serializer.fromXml(xml);
		Assert.assertEquals(2, topic.subTopics.length);
		Assert.assertEquals("Sub Topic 1", topic.subTopics[0].title);
		Assert.assertEquals("Sub Topic 2", topic.subTopics[1].title);
	}

	[Test]
	public function fromXml_array_null():void
	{
		var xml:XML =
			<topic>
				<sub-topics type="array" nil="true"/>
			</topic>;
			
		topic = serializer.fromXml(xml);
		Assert.assertEquals(0, topic.subTopics.length);
	}

	[Test]
	public function fromXml_rootArray():void
	{
		var xml:XML =
			<topics type="array">
				<topic>
					<title>Topic 1</title>
				</topic>
				<topic>
					<title>Topic 2</title>
				</topic>
			</topics>;
			
		var topics:Array = serializer.fromXml(xml);
		Assert.assertEquals(2, topics.length);
		Assert.assertEquals("Topic 1", topics[0].title);
		Assert.assertEquals("Topic 2", topics[1].title);
	}

	//---------------------------------
	//  Tear down
	//---------------------------------
	
	[After]
	public function tearDown():void
	{
		serializer = null;
		topic = null;
	}
}
}