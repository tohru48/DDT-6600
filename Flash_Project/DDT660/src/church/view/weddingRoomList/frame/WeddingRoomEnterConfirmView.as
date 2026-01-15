package church.view.weddingRoomList.frame
{
   import church.controller.ChurchRoomListController;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.ChurchRoomInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class WeddingRoomEnterConfirmView extends BaseAlerFrame
   {
      
      private var _controller:ChurchRoomListController;
      
      private var _churchRoomInfo:ChurchRoomInfo;
      
      private var _bg:Scale9CornerImage;
      
      private var _bmpRoomName:FilterFrameText;
      
      private var _bmpGroom:FilterFrameText;
      
      private var _bmpBride:FilterFrameText;
      
      private var _bmpCount:FilterFrameText;
      
      private var _flower:Bitmap;
      
      private var _bmpSpareTime:FilterFrameText;
      
      private var _bmpLineBox:ScaleBitmapImage;
      
      private var _bmpDescription:FilterFrameText;
      
      private var _bmpLine1:Bitmap;
      
      private var _imgLine:MutipleImage;
      
      private var _imgLine3:Image;
      
      private var _imgLine4:Image;
      
      private var _imgLine5:Image;
      
      private var _roomNameText:FilterFrameText;
      
      private var _groomText:FilterFrameText;
      
      private var _grideText:FilterFrameText;
      
      private var _countText:FilterFrameText;
      
      private var _spareTime:FilterFrameText;
      
      private var _alertInfo:AlertInfo;
      
      private var _txtDescription:TextArea;
      
      private var _textDescriptionBg:Sprite;
      
      private var _weddingRoomEnterInputPasswordView:WeddingRoomEnterInputPasswordView;
      
      private var _titleTxt:FilterFrameText;
      
      public function WeddingRoomEnterConfirmView()
      {
         super();
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      public function set controller(value:ChurchRoomListController) : void
      {
         this._controller = value;
      }
      
      public function set churchRoomInfo(value:ChurchRoomInfo) : void
      {
         this._churchRoomInfo = value;
         this._roomNameText.text = this._churchRoomInfo.roomName;
         this._groomText.text = this._churchRoomInfo.groomName;
         this._grideText.text = this._churchRoomInfo.brideName;
         this._countText.text = this._churchRoomInfo.currentNum.toString();
         var hour:int = (this._churchRoomInfo.valideTimes * 60 - (TimeManager.Instance.Now().time / (1000 * 60) - this._churchRoomInfo.creactTime.time / (1000 * 60))) / 60;
         if(hour >= 0)
         {
            hour = Math.floor(hour);
         }
         else
         {
            hour = Math.ceil(hour);
         }
         var min:int = int(this._churchRoomInfo.valideTimes * 60 - (TimeManager.Instance.Now().time / (1000 * 60) - this._churchRoomInfo.creactTime.time / (1000 * 60))) % 60;
         if(hour < 0 || min < 0)
         {
            this._spareTime.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.time");
         }
         else
         {
            this._spareTime.text = hour.toString() + LanguageMgr.GetTranslation("hours") + min.toString() + LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.minute");
         }
         this._txtDescription.text = this._churchRoomInfo.discription;
      }
      
      private function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.moveEnable = false;
         this._alertInfo.submitLabel = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.into");
         info = this._alertInfo;
         this.escEnable = true;
         this._flower = ComponentFactory.Instance.creatBitmap("asset.churchroomlist.flowers");
         this._flower.scaleY = 0.9;
         this._flower.scaleX = 0.9;
         PositionUtils.setPos(this._flower,"WeddingRoomEnterConfirmView.titleFlowers.pos");
         addToContent(this._flower);
         this._titleTxt = ComponentFactory.Instance.creat("ddtchurchroomlist.frame.WeddingRoomEnterConfirmView.titleText");
         this._titleTxt.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.titleText");
         addToContent(this._titleTxt);
         this._bg = ComponentFactory.Instance.creat("church.main.roomEnterConfirmBg");
         addToContent(this._bg);
         this._bmpRoomName = ComponentFactory.Instance.creat("church.main.WeddingRoomEnterConfirmView.roomNameTxt");
         this._bmpRoomName.text = LanguageMgr.GetTranslation("church.main.WeddingRoomEnterConfirmView.roomNameTxt");
         addToContent(this._bmpRoomName);
         this._bmpGroom = ComponentFactory.Instance.creat("church.main.WeddingRoomEnterConfirmView.bridegroomTxt");
         this._bmpGroom.text = LanguageMgr.GetTranslation("church.main.WeddingRoomEnterConfirmView.bridegroomTxt");
         addToContent(this._bmpGroom);
         this._bmpBride = ComponentFactory.Instance.creat("church.main.WeddingRoomEnterConfirmView.brideTxt");
         this._bmpBride.text = LanguageMgr.GetTranslation("church.main.WeddingRoomEnterConfirmView.brideTxt");
         addToContent(this._bmpBride);
         this._bmpCount = ComponentFactory.Instance.creat("church.main.WeddingRoomEnterConfirmView.numberTxt");
         this._bmpCount.text = LanguageMgr.GetTranslation("church.main.WeddingRoomEnterConfirmView.numberTxt");
         addToContent(this._bmpCount);
         this._bmpSpareTime = ComponentFactory.Instance.creat("church.main.WeddingRoomEnterConfirmView.timeTxt");
         this._bmpSpareTime.text = LanguageMgr.GetTranslation("church.main.WeddingRoomEnterConfirmView.timeTxt");
         addToContent(this._bmpSpareTime);
         this._bmpLineBox = ComponentFactory.Instance.creatComponentByStylename("church.roomEnterLineBoxAsset");
         addToContent(this._bmpLineBox);
         this._bmpDescription = ComponentFactory.Instance.creat("church.main.WeddingRoomEnterConfirmView.describeTxt");
         this._bmpDescription.text = LanguageMgr.GetTranslation("church.main.WeddingRoomEnterConfirmView.describeTxt");
         addToContent(this._bmpDescription);
         this._imgLine = ComponentFactory.Instance.creatComponentByStylename("church.roomEnterLineAsset");
         addToContent(this._imgLine);
         this._roomNameText = ComponentFactory.Instance.creat("church.main.roomEnterRoomNameTextAsset");
         addToContent(this._roomNameText);
         this._groomText = ComponentFactory.Instance.creat("church.main.roomEnterGroomTextAsset");
         addToContent(this._groomText);
         this._grideText = ComponentFactory.Instance.creat("church.main.roomEnterBrideTextAsset");
         addToContent(this._grideText);
         this._countText = ComponentFactory.Instance.creat("church.main.roomEnterCountTextAsset");
         addToContent(this._countText);
         this._spareTime = ComponentFactory.Instance.creat("church.main.roomEnterSpareTimeTextAsset");
         addToContent(this._spareTime);
         this._txtDescription = ComponentFactory.Instance.creat("church.view.weddingRoomList.frame.txtRoomEnterDescriptionAsset");
         addToContent(this._txtDescription);
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function onFrameResponse(evt:FrameEvent) : void
      {
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.enterRoomConfirm();
         }
      }
      
      private function enterRoomConfirm() : void
      {
         SoundManager.instance.play("008");
         if(this._churchRoomInfo.isLocked)
         {
            this._weddingRoomEnterInputPasswordView = ComponentFactory.Instance.creat("church.main.weddingRoomList.WeddingRoomEnterInputPasswordView");
            this._weddingRoomEnterInputPasswordView.churchRoomInfo = this._churchRoomInfo;
            this._weddingRoomEnterInputPasswordView.submitButtonEnable = false;
            this._weddingRoomEnterInputPasswordView.show();
         }
         else
         {
            SocketManager.Instance.out.sendEnterRoom(this._churchRoomInfo.id,"");
         }
         this.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function removeView() : void
      {
         if(Boolean(this._titleTxt))
         {
            if(Boolean(this._titleTxt.parent))
            {
               this._titleTxt.parent.removeChild(this._titleTxt);
            }
            this._titleTxt.dispose();
         }
         this._titleTxt = null;
         if(Boolean(this._flower))
         {
            if(Boolean(this._flower.parent))
            {
               this._flower.parent.removeChild(this._flower);
            }
            this._flower.bitmapData.dispose();
            this._flower.bitmapData = null;
         }
         this._flower = null;
         if(Boolean(this._bg))
         {
            if(Boolean(this._bg.parent))
            {
               this._bg.parent.removeChild(this._bg);
            }
            this._bg.dispose();
         }
         this._bg = null;
         if(Boolean(this._bmpRoomName))
         {
            if(Boolean(this._bmpRoomName.parent))
            {
               this._bmpRoomName.parent.removeChild(this._bmpRoomName);
            }
         }
         this._bmpRoomName = null;
         if(Boolean(this._bmpGroom))
         {
            if(Boolean(this._bmpGroom.parent))
            {
               this._bmpGroom.parent.removeChild(this._bmpGroom);
            }
         }
         this._bmpGroom = null;
         if(Boolean(this._bmpBride))
         {
            if(Boolean(this._bmpBride.parent))
            {
               this._bmpBride.parent.removeChild(this._bmpBride);
            }
         }
         this._bmpBride = null;
         if(Boolean(this._bmpCount))
         {
            if(Boolean(this._bmpCount.parent))
            {
               this._bmpCount.parent.removeChild(this._bmpCount);
            }
         }
         this._bmpCount = null;
         if(Boolean(this._bmpSpareTime))
         {
            if(Boolean(this._bmpSpareTime.parent))
            {
               this._bmpSpareTime.parent.removeChild(this._bmpSpareTime);
            }
         }
         this._bmpSpareTime = null;
         if(Boolean(this._bmpLineBox))
         {
            if(Boolean(this._bmpLineBox.parent))
            {
               this._bmpLineBox.parent.removeChild(this._bmpLineBox);
            }
         }
         this._bmpLineBox = null;
         if(Boolean(this._bmpDescription))
         {
            if(Boolean(this._bmpDescription.parent))
            {
               this._bmpDescription.parent.removeChild(this._bmpDescription);
            }
         }
         this._bmpDescription = null;
         if(Boolean(this._imgLine))
         {
            if(Boolean(this._imgLine.parent))
            {
               this._imgLine.parent.removeChild(this._imgLine);
            }
         }
         this._imgLine = null;
         if(Boolean(this._roomNameText))
         {
            if(Boolean(this._roomNameText.parent))
            {
               this._roomNameText.parent.removeChild(this._roomNameText);
            }
            this._roomNameText.dispose();
         }
         this._roomNameText = null;
         if(Boolean(this._groomText))
         {
            if(Boolean(this._groomText.parent))
            {
               this._groomText.parent.removeChild(this._groomText);
            }
            this._groomText.dispose();
         }
         this._groomText = null;
         if(Boolean(this._grideText))
         {
            if(Boolean(this._grideText.parent))
            {
               this._grideText.parent.removeChild(this._grideText);
            }
            this._grideText.dispose();
         }
         this._grideText = null;
         if(Boolean(this._countText))
         {
            if(Boolean(this._countText.parent))
            {
               this._countText.parent.removeChild(this._countText);
            }
            this._countText.dispose();
         }
         this._countText = null;
         if(Boolean(this._spareTime))
         {
            if(Boolean(this._spareTime.parent))
            {
               this._spareTime.parent.removeChild(this._spareTime);
            }
            this._spareTime.dispose();
         }
         this._spareTime = null;
         this._alertInfo = null;
         this._txtDescription = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this.removeView();
      }
   }
}

