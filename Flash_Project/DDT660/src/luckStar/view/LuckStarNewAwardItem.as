package luckStar.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class LuckStarNewAwardItem extends Sprite implements Disposeable
   {
      
      private var nameText:FilterFrameText;
      
      private var awardText:FilterFrameText;
      
      private var _bg:Bitmap;
      
      public function LuckStarNewAwardItem()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.nameText = ComponentFactory.Instance.creat("luckyStar.rankItem.newRankNmaeText");
         this.awardText = ComponentFactory.Instance.creat("luckyStar.rankItem.newRankAwardText");
         this._bg = ComponentFactory.Instance.creat("luckyStar.view.line");
         addChild(this._bg);
         addChild(this.nameText);
         addChild(this.awardText);
      }
      
      public function setText($name:String, $award:int, $count:int) : void
      {
         var goods:String = null;
         if(Boolean(ItemManager.Instance.getTemplateById($award)))
         {
            this.nameText.text = $name;
            goods = ItemManager.Instance.getTemplateById($award).Name + " x " + $count.toString();
            if(ItemManager.Instance.getTemplateById($award).Quality >= 5)
            {
               goods = goods.replace(goods,"<font color=\'#ff0000\'>" + goods + "</font>");
            }
            this.awardText.htmlText = goods;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this.nameText);
         this.nameText = null;
         ObjectUtils.disposeObject(this.awardText);
         this.awardText = null;
      }
   }
}

