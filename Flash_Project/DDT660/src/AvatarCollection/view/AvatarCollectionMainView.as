package AvatarCollection.view
{
   import AvatarCollection.AvatarCollectionManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class AvatarCollectionMainView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _vbox:VBox;
      
      private var _unitList:Vector.<AvatarCollectionUnitView>;
      
      private var _rightView:AvatarCollectionRightView;
      
      private var _canActivitySCB:SelectedCheckButton;
      
      private var _canBuySCB:SelectedCheckButton;
      
      private var _btnHelp:BaseButton;
      
      private var _helpFrame:Frame;
      
      private var _bgHelp:Scale9CornerImage;
      
      private var _content:MovieClip;
      
      private var _btnOk:TextButton;
      
      private var honorAll:int;
      
      public function AvatarCollectionMainView()
      {
         super();
         this.x = 12;
         this.y = 53;
         AvatarCollectionManager.instance.initShopItemInfoList();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var unitView:AvatarCollectionUnitView = null;
         var array:Array = null;
         var k:int = 0;
         var alert:AvatarCollectionDelayConfirmFrame = null;
         var totalCount:int = 0;
         var activityCount:int = 0;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.avatarCollMainView.bg");
         this._rightView = new AvatarCollectionRightView();
         PositionUtils.setPos(this._rightView,"avatarColl.mainView.rightViewPos");
         this._canActivitySCB = ComponentFactory.Instance.creatComponentByStylename("avatarColl.canActivitySCB");
         this._canBuySCB = ComponentFactory.Instance.creatComponentByStylename("avatarColl.canBuySCB");
         this._vbox = new VBox();
         PositionUtils.setPos(this._vbox,"avatarColl.mainView.vboxPos");
         this._vbox.spacing = 2;
         this._unitList = new Vector.<AvatarCollectionUnitView>();
         for(var i:int = 1; i <= 2; i++)
         {
            unitView = new AvatarCollectionUnitView(i,this._rightView);
            unitView.addEventListener(AvatarCollectionUnitView.SELECTED_CHANGE,this.refreshView,false,0,true);
            this._vbox.addChild(unitView);
            this._unitList.push(unitView);
         }
         if(AvatarCollectionManager.instance.skipIdArray != null && AvatarCollectionManager.instance.skipIdArray.length > 0 && AvatarCollectionManager.instance.skipFlag)
         {
            array = AvatarCollectionManager.instance.skipIdArray;
            for(k = 0; k < array.length; k++)
            {
               totalCount = int(array[k].totalItemList.length);
               activityCount = int(array[k].totalActivityItemCount);
               if(activityCount == totalCount)
               {
                  this.honorAll += array[k].needHonor * 2;
               }
               else
               {
                  this.honorAll += array[k].needHonor;
               }
            }
            alert = ComponentFactory.Instance.creatComponentByStylename("avatarColl.delayConfirmFrame");
            alert.show(this.honorAll,0);
            alert.addEventListener(FrameEvent.RESPONSE,this.__onConfirmResponse);
            LayerManager.Instance.addToLayer(alert,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         this._btnHelp = ComponentFactory.Instance.creatComponentByStylename("cardSystem.texpSystem.btnHelp");
         this._btnHelp.x = 725;
         this._btnHelp.y = -51;
         addChild(this._btnHelp);
         addChild(this._bg);
         addChild(this._vbox);
         addChild(this._canActivitySCB);
         addChild(this._canBuySCB);
         addChild(this._rightView);
      }
      
      protected function __onConfirmResponse(event:FrameEvent) : void
      {
         var tmpValue:int = 0;
         SoundManager.instance.play("008");
         var alert:AvatarCollectionDelayConfirmFrame = event.currentTarget as AvatarCollectionDelayConfirmFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onConfirmResponse);
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            tmpValue = alert.selectValue;
            if(PlayerManager.Instance.Self.myHonor < this.honorAll * tmpValue)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("avatarCollection.delayConfirmFrame.noEnoughHonor"));
            }
            else
            {
               SocketManager.Instance.out.sendAvatarCollectionDelayTime(-1,tmpValue);
               AvatarCollectionManager.instance.skipIdArray = [];
               AvatarCollectionManager.instance.skipIdArray = null;
               AvatarCollectionManager.instance.skipFlag = false;
            }
         }
         alert.dispose();
      }
      
      private function initEvent() : void
      {
         this._canActivitySCB.addEventListener(MouseEvent.CLICK,this.canActivityChangeHandler,false,0,true);
         this._canBuySCB.addEventListener(MouseEvent.CLICK,this.canBuyChangeHandler,false,0,true);
         this._btnHelp.addEventListener(MouseEvent.CLICK,this.__helpClick);
      }
      
      protected function __helpClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this._helpFrame)
         {
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.main");
            this._helpFrame.titleText = LanguageMgr.GetTranslation("avatarCollection.helpTxt");
            this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
            this._bgHelp = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.bgHelp");
            this._content = ComponentFactory.Instance.creatCustomObject("avatarColl.help.content");
            this._btnOk = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.btnOk");
            this._btnOk.text = LanguageMgr.GetTranslation("ok");
            this._btnOk.addEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            this._helpFrame.addToContent(this._bgHelp);
            this._helpFrame.addToContent(this._content);
            this._helpFrame.addToContent(this._btnOk);
         }
         LayerManager.Instance.addToLayer(this._helpFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __helpFrameRespose(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.playButtonSound();
            this._helpFrame.parent.removeChild(this._helpFrame);
         }
      }
      
      private function __closeHelpFrame(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._helpFrame.parent.removeChild(this._helpFrame);
      }
      
      private function refreshView(event:Event) : void
      {
         var tmp:AvatarCollectionUnitView = null;
         var tmpTargetUnit:AvatarCollectionUnitView = event.target as AvatarCollectionUnitView;
         for each(tmp in this._unitList)
         {
            if(tmp != tmpTargetUnit)
            {
               tmp.unextendHandler();
            }
         }
         this._vbox.arrange();
      }
      
      private function canBuyChangeHandler(event:MouseEvent) : void
      {
         var tmp:AvatarCollectionUnitView = null;
         SoundManager.instance.play("008");
         for each(tmp in this._unitList)
         {
            tmp.isBuyFilter = this._canBuySCB.selected;
         }
         if(this._canBuySCB.selected)
         {
            this._canActivitySCB.selected = false;
         }
      }
      
      private function canActivityChangeHandler(event:MouseEvent) : void
      {
         var tmp:AvatarCollectionUnitView = null;
         SoundManager.instance.play("008");
         for each(tmp in this._unitList)
         {
            tmp.isFilter = this._canActivitySCB.selected;
         }
         if(this._canActivitySCB.selected)
         {
            this._canBuySCB.selected = false;
         }
      }
      
      private function removeEvent() : void
      {
         this._canActivitySCB.removeEventListener(MouseEvent.CLICK,this.canActivityChangeHandler);
         this._canBuySCB.removeEventListener(MouseEvent.CLICK,this.canBuyChangeHandler);
         this._btnHelp.removeEventListener(MouseEvent.CLICK,this.__helpClick);
      }
      
      public function dispose() : void
      {
         var tmp:AvatarCollectionUnitView = null;
         this.removeEvent();
         AvatarCollectionManager.instance.skipFlag = true;
         for each(tmp in this._unitList)
         {
            tmp.removeEventListener(AvatarCollectionUnitView.SELECTED_CHANGE,this.refreshView);
         }
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._vbox = null;
         this._unitList = null;
         this._rightView = null;
         this._canActivitySCB = null;
         this._canBuySCB = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

