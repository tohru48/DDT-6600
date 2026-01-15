package sevenDayTarget.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import sevenDayTarget.model.NewPlayerRewardInfo;
   
   public class NewPlayerRewardItem extends Sprite
   {
      
      private var _bg:Bitmap;
      
      private var _titleText:FilterFrameText;
      
      private var _getRewardBnt:BaseButton;
      
      private var _rewardList:SimpleTileList;
      
      private var _info:NewPlayerRewardInfo;
      
      public function NewPlayerRewardItem()
      {
         super();
      }
      
      public function setInfo(info:NewPlayerRewardInfo) : void
      {
         var cell:NewPlayerRewardCell = null;
         var itemInfo:InventoryItemInfo = null;
         var arr:Array = info.rewardArr;
         var type:int = info.bgType;
         var len:int = int(arr.length);
         var isfinished:Boolean = info.finished;
         var getRewarded:Boolean = info.getRewarded;
         this._info = info;
         if(!isfinished)
         {
            this._getRewardBnt = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.newplayerRewardItemRewardBnt");
            this._getRewardBnt.enable = false;
         }
         else if(isfinished && !getRewarded)
         {
            this._getRewardBnt = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.newplayerRewardItemRewardBnt");
            this._getRewardBnt.enable = true;
         }
         else if(getRewarded)
         {
            this._getRewardBnt = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.newplayerRewardItemRewardBnt2");
            this._getRewardBnt.enable = false;
         }
         this._getRewardBnt.addEventListener(MouseEvent.CLICK,this.__getReward);
         if(len <= 4 && len > 0 && type == NewPlayerRewardMainView.CHONGZHI)
         {
            this._bg = ComponentFactory.Instance.creat("newSevenDayAndNewPlayer.chongzhi");
            this._titleText = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.titletext1");
            this._titleText.text = LanguageMgr.GetTranslation("newSevenDayAndNewPlayer.chongzhitext",info.num);
         }
         else if(len > 4 && len <= 8 && type == NewPlayerRewardMainView.CHONGZHI)
         {
            this._bg = ComponentFactory.Instance.creat("newSevenDayAndNewPlayer.chongzhibig");
            this._titleText = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.titletext1");
            this._titleText.text = LanguageMgr.GetTranslation("newSevenDayAndNewPlayer.chongzhitext",info.num);
         }
         else if(len <= 4 && len > 0 && type == NewPlayerRewardMainView.XIAOFEI)
         {
            this._bg = ComponentFactory.Instance.creat("newSevenDayAndNewPlayer.xiaofei");
            this._titleText = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.titletext2");
            this._titleText.text = LanguageMgr.GetTranslation("newSevenDayAndNewPlayer.xiaofeitext",info.num);
         }
         else if(len > 4 && len <= 8 && type == NewPlayerRewardMainView.XIAOFEI)
         {
            this._bg = ComponentFactory.Instance.creat("newSevenDayAndNewPlayer.xiaofeiibig");
            this._titleText = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.titletext2");
            this._titleText.text = LanguageMgr.GetTranslation("newSevenDayAndNewPlayer.xiaofeitext",info.num);
         }
         else
         {
            this._titleText = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.titletext3");
            this._titleText.text = LanguageMgr.GetTranslation("newSevenDayAndNewPlayer.hunlitext");
         }
         PositionUtils.setPos(this._titleText,"newSevenDayAndNewPlayer.newplayerRewardItemTitlePos");
         if(len <= 4 && len > 0)
         {
            PositionUtils.setPos(this._getRewardBnt,"newSevenDayAndNewPlayer.newplayerRewardItemRewardBntPos");
         }
         else
         {
            PositionUtils.setPos(this._getRewardBnt,"newSevenDayAndNewPlayer.newplayerRewardItemRewardBntPos2");
         }
         this._rewardList = ComponentFactory.Instance.creat("newPlayerReward.simpleTileList.rewardList",[4]);
         if(Boolean(this._bg))
         {
            addChild(this._bg);
         }
         addChild(this._titleText);
         addChild(this._getRewardBnt);
         addChild(this._rewardList);
         for(var i:int = 0; i < arr.length; i++)
         {
            cell = new NewPlayerRewardCell();
            itemInfo = arr[i] as InventoryItemInfo;
            cell.info = ItemManager.Instance.getTemplateById(itemInfo.ItemID);
            cell.itemNum = itemInfo.Count + "";
            this._rewardList.addChild(cell);
         }
      }
      
      private function __getReward(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(Boolean(this._getRewardBnt))
         {
            this._getRewardBnt.backStyle = "newSevenDayAndNewPlayer.getRewardBG1";
            this._getRewardBnt.enable = false;
         }
         var questionId:int = this._info.questId;
         SocketManager.Instance.out.newPlayerReward_getReward(questionId);
      }
      
      private function initView(type:int) : void
      {
      }
   }
}

