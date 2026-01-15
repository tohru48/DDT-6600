package Dice.View
{
   import Dice.Controller.DiceController;
   import Dice.VO.DiceAwardCell;
   import Dice.VO.DiceAwardInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class DiceTreasureBoxTip extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _line:ScaleBitmapImage;
      
      private var _script:FilterFrameText;
      
      public function DiceTreasureBoxTip()
      {
         super();
         this.preInitialize();
         this.initialize();
         this.addEvent();
      }
      
      private function preInitialize() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.dice.treasureBox.tip.BG");
         this._line = ComponentFactory.Instance.creatComponentByStylename("asset.dice.treasureBox.tip.line");
         this._script = ComponentFactory.Instance.creatComponentByStylename("asset.dice.treasureBox.tip.script");
      }
      
      public function update() : void
      {
         this.removeAllChildren();
         this.initialize();
      }
      
      private function removeAllChildren() : void
      {
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
      }
      
      private function initialize() : void
      {
         addChild(this._bg);
         addChild(this._line);
         addChild(this._script);
         this._script.text = LanguageMgr.GetTranslation("dice.treasureBoxTip.script",DiceController.Instance.LuckIntegralLevel + 1);
         this.addAwardList();
      }
      
      private function addAwardList() : void
      {
         var list:Vector.<DiceAwardCell> = null;
         var j:int = 0;
         var i:int = 0;
         list = (DiceController.Instance.AwardLevelInfo[DiceController.Instance.LuckIntegralLevel] as DiceAwardInfo).templateInfo;
         j = 0;
         if(list != null)
         {
            for(i = 0; i < list.length; i++)
            {
               if(Boolean(list[i]))
               {
                  j++;
                  list[i].x = 10;
                  list[i].y = j * 47 + 11;
                  addChild(list[i]);
               }
            }
            this._bg.height = list[i - 1].y + 55;
         }
      }
      
      private function addEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
      }
   }
}

