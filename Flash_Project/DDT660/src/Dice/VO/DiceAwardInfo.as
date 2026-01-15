package Dice.VO
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import flash.display.Bitmap;
   
   public class DiceAwardInfo
   {
      
      private var _level:int;
      
      private var _integral:int;
      
      private var _templateInfo:Vector.<DiceAwardCell>;
      
      public function DiceAwardInfo($level:int, $integral:int, $templateString:String)
      {
         super();
         this._templateInfo = new Vector.<DiceAwardCell>();
         this._level = $level;
         this._integral = $integral;
         this.setTemplateInfo = $templateString;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function get integral() : int
      {
         return this._integral;
      }
      
      public function get templateInfo() : Vector.<DiceAwardCell>
      {
         return this._templateInfo;
      }
      
      private function set setTemplateInfo(templateString:String) : void
      {
         var cell:DiceAwardCell = null;
         var info:ItemTemplateInfo = null;
         var str:String = null;
         if(templateString == null || templateString == "")
         {
            return;
         }
         var arr:Array = templateString.split(",");
         for(var i:int = int(arr.length); i > 0; i--)
         {
            str = arr[i - 1];
            if(str != null && str != "")
            {
               info = ItemManager.Instance.getTemplateById(int(str.split("|")[0]));
               cell = new DiceAwardCell(info,int(str.split("|")[1]));
               this._templateInfo.push(cell);
            }
         }
      }
      
      public function dispose() : void
      {
         for(var i:int = int(this._templateInfo.length); i > 0; i--)
         {
            if(Boolean(this._templateInfo[i - 1]))
            {
               this._templateInfo[i - 1].dispose();
               this._templateInfo[i - 1] = null;
            }
         }
         this._templateInfo = null;
      }
   }
}

