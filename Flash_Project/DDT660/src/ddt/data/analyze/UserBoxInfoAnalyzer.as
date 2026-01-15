package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.box.GradeBoxInfo;
   import ddt.data.box.TimeBoxInfo;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   
   public class UserBoxInfoAnalyzer extends DataAnalyzer
   {
      
      private var _xml:XML;
      
      private var _goodsList:XMLList;
      
      public var timeBoxList:DictionaryData;
      
      public var gradeBoxList:DictionaryData;
      
      public var boxTemplateID:Dictionary;
      
      public var timeBoxListHigh:DictionaryData;
      
      public function UserBoxInfoAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         this._xml = new XML(data);
         if(this._xml.@value == "true")
         {
            this.timeBoxList = new DictionaryData();
            this.timeBoxListHigh = new DictionaryData();
            this.gradeBoxList = new DictionaryData();
            this.boxTemplateID = new Dictionary();
            this._goodsList = this._xml..Item;
            this.parseShop();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      private function parseShop() : void
      {
         var type:int = 0;
         var timeInfo:TimeBoxInfo = null;
         var gradeInfo:GradeBoxInfo = null;
         var timeInfoI:TimeBoxInfo = null;
         for(var i:int = 0; i < this._goodsList.length(); i++)
         {
            type = int(this._goodsList[i].@Type);
            switch(type)
            {
               case 0:
                  timeInfo = new TimeBoxInfo();
                  ObjectUtils.copyPorpertiesByXML(timeInfo,this._goodsList[i]);
                  this.boxTemplateID[timeInfo.TemplateID] = timeInfo.TemplateID;
                  if(timeInfo.Level > 20)
                  {
                     this.timeBoxListHigh.add(timeInfo.ID,timeInfo);
                  }
                  else
                  {
                     this.timeBoxList.add(timeInfo.ID,timeInfo);
                  }
                  break;
               case 1:
                  gradeInfo = new GradeBoxInfo();
                  ObjectUtils.copyPorpertiesByXML(gradeInfo,this._goodsList[i]);
                  this.boxTemplateID[gradeInfo.TemplateID] = gradeInfo.TemplateID;
                  this.gradeBoxList.add(gradeInfo.ID,gradeInfo);
                  break;
               case 2:
                  timeInfoI = new TimeBoxInfo();
                  ObjectUtils.copyPorpertiesByXML(timeInfoI,this._goodsList[i]);
                  this.boxTemplateID[timeInfoI.TemplateID] = timeInfoI.TemplateID;
                  break;
            }
         }
         onAnalyzeComplete();
      }
      
      private function getXML() : XML
      {
         return <Result value="true" message="Success!">
  <Item ID="1" Type="0" Level="20" Condition="15" TemplateID="1120090"/>
  <Item ID="2" Type="0" Level="20" Condition="40" TemplateID="1120091"/>
  <Item ID="3" Type="0" Level="20" Condition="60" TemplateID="1120092"/>
  <Item ID="4" Type="0" Level="20" Condition="75" TemplateID="1120093"/>
  <Item ID="6" Type="1" Level="4" Condition="1" TemplateID="1120071"/>
  <Item ID="7" Type="1" Level="5" Condition="1" TemplateID="1120072"/>
  <Item ID="8" Type="1" Level="8" Condition="1" TemplateID="1120073"/>
  <Item ID="9" Type="1" Level="10" Condition="1" TemplateID="1120074"/>
  <Item ID="10" Type="1" Level="11" Condition="1" TemplateID="1120075"/>
  <Item ID="11" Type="1" Level="12" Condition="1" TemplateID="1120076"/>
  <Item ID="12" Type="1" Level="15" Condition="1" TemplateID="1120077"/>
  <Item ID="13" Type="1" Level="20" Condition="1" TemplateID="1120078"/>
  <Item ID="14" Type="1" Level="4" Condition="0" TemplateID="1120081"/>
  <Item ID="15" Type="1" Level="5" Condition="0" TemplateID="1120082"/>
  <Item ID="16" Type="1" Level="8" Condition="0" TemplateID="1120083"/>
  <Item ID="17" Type="1" Level="10" Condition="0" TemplateID="1120084"/>
  <Item ID="18" Type="1" Level="11" Condition="0" TemplateID="1120085"/>
  <Item ID="19" Type="1" Level="12" Condition="0" TemplateID="1120086"/>
  <Item ID="20" Type="1" Level="15" Condition="0" TemplateID="1120087"/>
  <Item ID="21" Type="1" Level="20" Condition="0" TemplateID="1120088"/>
  <Item ID="14" Type="2" Level="4" Condition="0" TemplateID="112112"/>
  <Item ID="15" Type="2" Level="5" Condition="0" TemplateID="112113"/>
  <Item ID="16" Type="2" Level="8" Condition="0" TemplateID="112114"/>
  <Item ID="17" Type="2" Level="10" Condition="0" TemplateID="112115"/>
  <Item ID="18" Type="2" Level="11" Condition="0" TemplateID="112116"/>
  <Item ID="19" Type="2" Level="12" Condition="0" TemplateID="112117"/>
  <Item ID="20" Type="2" Level="15" Condition="0" TemplateID="112118"/>
 <Item ID="21" Type="2" Level="20" Condition="0" TemplateID="112119"/>
 <Item ID="21" Type="2" Level="20" Condition="0" TemplateID="112120"/>
</Result>;
      }
   }
}

