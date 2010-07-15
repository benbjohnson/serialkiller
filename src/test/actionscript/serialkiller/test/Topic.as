package serialkiller.test
{
public class Topic
{
	[DataType("integer")]
	public var id:Number;
	public var id2:int;

	public var temperature:Number;
	
	[DataType("decimal")]
	public var salary:Number;

	[DataType("datetime")]
	public var writtenOn:Date;

	[Bindable]
	public var title:String;
	
	public var bonusTime:Date;
	public var lastRead:Date;


	public var authorName:String;
	public var approved:Boolean;
	public var repliesCount:int;
	public var content:String;
	public var authorEmailAddress:String;
	public var parentId:Number;

	public var parentTopic:Topic;

	public var subTopics:Array;

}
}