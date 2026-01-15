package Dice.View
{
   import Dice.Controller.DiceController;
   import Dice.Event.DiceEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class DiceRewarditemsBar extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _caption:FilterFrameText;
      
      private var _line:ScaleBitmapImage;
      
      private var _titleBG:MutipleImage;
      
      private var _listPanel:ScrollPanel;
      
      private var _list:VBox;
      
      private var _tempStr:String;
      
      public function DiceRewarditemsBar()
      {
         super();
         this.preInitialize();
         this.initialize();
         this.addEvent();
      }
      
      private function preInitialize() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.dice.reward.BG");
         this._caption = ComponentFactory.Instance.creatComponentByStylename("asset.dice.reward.caption");
         this._titleBG = ComponentFactory.Instance.creatComponentByStylename("asset.dice.reward.title.bg");
         this._listPanel = ComponentFactory.Instance.creatComponentByStylename("asset.dice.reward.panel");
         this._list = ComponentFactory.Instance.creatComponentByStylename("asset.dice.reward.listVbox");
      }
      
      private function initialize() : void
      {
         addChild(this._bg);
         addChild(this._titleBG);
         addChild(this._caption);
         this._caption.text = LanguageMgr.GetTranslation("dice.reward.title");
         addChild(this._listPanel);
         this._listPanel.setView(this._list);
         this._listPanel.invalidateViewport(true);
      }
      
      private function addEvent() : void
      {
         DiceController.Instance.addEventListener(DiceEvent.GET_DICE_RESULT_DATA,this.__onAddRewardItem);
         DiceController.Instance.addEventListener(DiceEvent.PLAYER_ISWALKING,this.__onPlayerStateChanged);
      }
      
      private function __onAddRewardItem(event:DiceEvent) : void
      {
         this._tempStr = String(event.resultData.rewardItem);
      }
      
      private function __onPlayerStateChanged(event:DiceEvent) : void
      {
         var item:FilterFrameText = null;
         if(Boolean(event.resultData) && !event.resultData.isWalking)
         {
            item = ComponentFactory.Instance.creatComponentByStylename("asset.dice.reward.item");
            item.text = this._tempStr;
            if(item.numLines == 1)
            {
               item.height = 19;
            }
            this._list.addChild(item);
            this._listPanel.invalidateViewport(true);
         }
      }
      
      private function removeEvent() : void
      {
         DiceController.Instance.removeEventListener(DiceEvent.GET_DICE_RESULT_DATA,this.__onAddRewardItem);
         DiceController.Instance.removeEventListener(DiceEvent.PLAYER_ISWALKING,this.__onPlayerStateChanged);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._titleBG);
         this._titleBG = null;
         ObjectUtils.disposeObject(this._listPanel);
         this._listPanel = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._caption);
         this._caption = null;
         ObjectUtils.disposeObject(this._line);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

