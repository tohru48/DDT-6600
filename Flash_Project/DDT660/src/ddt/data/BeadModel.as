package ddt.data
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.utils.Dictionary;
   
   public class BeadModel
   {
      
      private static var _ins:BeadModel;
      
      private var _beadDic:Dictionary = new Dictionary();
      
      public function BeadModel()
      {
         super();
      }
      
      public static function getInstance() : BeadModel
      {
         if(_ins == null)
         {
            _ins = ComponentFactory.Instance.creatCustomObject("BeadModel");
         }
         return _ins;
      }
      
      public function set beads(val:String) : void
      {
         var id:int = 0;
         var arr:Array = val.split(",");
         for each(id in arr)
         {
            this._beadDic[String(id)] = true;
         }
      }
      
      public function isBeadFromSmelt(id:int) : Boolean
      {
         return this._beadDic[String(id)] == true;
      }
      
      public function isAttackBead(item:ItemTemplateInfo) : Boolean
      {
         return this.isBeadFromSmelt(item.TemplateID) && item.Property2 == "1";
      }
      
      public function isDefenceBead(item:ItemTemplateInfo) : Boolean
      {
         return this.isBeadFromSmelt(item.TemplateID) && item.Property2 == "2";
      }
      
      public function isAttributeBead(item:ItemTemplateInfo) : Boolean
      {
         return this.isBeadFromSmelt(item.TemplateID) && item.Property2 == "3";
      }
   }
}

