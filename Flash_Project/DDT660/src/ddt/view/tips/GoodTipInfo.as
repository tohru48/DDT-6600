package ddt.view.tips
{
   import ddt.data.goods.ItemTemplateInfo;
   
   public class GoodTipInfo
   {
      
      public var itemInfo:ItemTemplateInfo;
      
      public var typeIsSecond:Boolean = true;
      
      public var isBalanceTip:Boolean;
      
      public var exp:int;
      
      public var upExp:int;
      
      public var beadName:String;
      
      public var latentEnergyItemId:int;
      
      public function GoodTipInfo()
      {
         super();
      }
   }
}

