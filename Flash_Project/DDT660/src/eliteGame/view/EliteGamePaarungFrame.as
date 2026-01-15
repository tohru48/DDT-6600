package eliteGame.view
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.DDT;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.PlayerPortraitView;
   import eliteGame.EliteGameController;
   import eliteGame.EliteGameEvent;
   import eliteGame.info.EliteGameTopSixteenInfo;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.TextEvent;
   import road7th.data.DictionaryData;
   
   public class EliteGamePaarungFrame extends Frame
   {
      
      private var _tilteBmp:Bitmap;
      
      private var _bigBg:Scale9CornerImage;
      
      private var _bg:Bitmap;
      
      private var _tip1:Bitmap;
      
      private var _tip2:Bitmap;
      
      private var _tip3:Bitmap;
      
      private var _tip4:Bitmap;
      
      private var _between30_40:SelectedCheckButton;
      
      private var _between41_50:SelectedCheckButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _isPress1:Boolean = false;
      
      private var _isPress2:Boolean = false;
      
      private var _texts:Object;
      
      private var _topSixteen:Vector.<EliteGameTopSixteenInfo>;
      
      private var _paarungRound:DictionaryData;
      
      private var _protrait:PlayerPortraitView;
      
      private var _playerInfo:PlayerInfo;
      
      public function EliteGamePaarungFrame()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("eliteGame.readyFrame.title");
         this._tilteBmp = ComponentFactory.Instance.creatBitmap("aaset.ddtelitgame.paarungFrame.titleBmp");
         this._bigBg = ComponentFactory.Instance.creatComponentByStylename("ddteliteGameGigBg");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.ddteliteGame.pauungview.BG");
         this._tip1 = ComponentFactory.Instance.creatBitmap("asset.eliteGame.pauungview.16");
         this._tip2 = ComponentFactory.Instance.creatBitmap("asset.eliteGame.pauungview.8");
         this._tip3 = ComponentFactory.Instance.creatBitmap("asset.eliteGame.pauungview.4");
         this._tip4 = ComponentFactory.Instance.creatBitmap("asset.eliteGame.pauungview.2");
         this._between30_40 = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.between30_40Btn");
         this._between41_50 = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.between41_50Btn");
         addToContent(this._tilteBmp);
         addToContent(this._bigBg);
         addToContent(this._bg);
         addToContent(this._tip1);
         addToContent(this._tip2);
         addToContent(this._tip3);
         addToContent(this._tip4);
         addToContent(this._between30_40);
         addToContent(this._between41_50);
         this._texts = new Object();
         this.createText(1,16);
         this.createText(2,8);
         this.createText(3,4);
         this.createText(4,2);
         this.createText(5,1);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._between30_40);
         this._btnGroup.addSelectItem(this._between41_50);
         if(PlayerManager.Instance.Self.Grade >= 41 && PlayerManager.Instance.Self.Grade <= DDT.THE_HIGHEST_LV)
         {
            this._btnGroup.selectIndex = 1;
         }
         else
         {
            this._btnGroup.selectIndex = 0;
         }
         PositionUtils.setPos(this._between30_40,"ddteliteGame.paarungView.select1");
         PositionUtils.setPos(this._between41_50,"ddteliteGame.paarungView.select2");
         EliteGameController.Instance.addEventListener(EliteGameEvent.TOP_SIXTEEN_READY,this.__dataReady);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         addEventListener(FrameEvent.RESPONSE,this.__responsehandler);
         this.setType(this._btnGroup.selectIndex);
      }
      
      private function createText(round:int, count:int) : void
      {
         var text:EliteGamePaarungText = null;
         this._texts[round] = new Vector.<EliteGamePaarungText>();
         for(var i:int = 1; i <= count; i++)
         {
            text = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.paarungView." + round + "." + i);
            text.addEventListener(TextEvent.LINK,this.__onTextClicked);
            text.mouseEnabled = true;
            addToContent(text);
            this._texts[round].push(text);
         }
      }
      
      protected function __onTextClicked(event:TextEvent) : void
      {
         var text:EliteGamePaarungText = event.currentTarget as EliteGamePaarungText;
         SoundManager.instance.play("008");
         PlayerInfoViewControl.viewByID(text.playerId);
         PlayerInfoViewControl.isOpenFromBag = false;
      }
      
      protected function __responsehandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      protected function __changeHandler(event:Event) : void
      {
         SoundManager.instance.play("008");
         this.setType(this._btnGroup.selectIndex);
      }
      
      private function setType(type:int) : void
      {
         switch(type)
         {
            case 0:
               if(!this._isPress1)
               {
                  SocketManager.Instance.out.sendGetPaarungDetail(1);
               }
               this._isPress1 = true;
               this.setData(EliteGameController.Instance.Model.topSixteen30_40,EliteGameController.Instance.Model.paarungRound30_40);
               break;
            case 1:
               if(!this._isPress2)
               {
                  SocketManager.Instance.out.sendGetPaarungDetail(2);
               }
               this._isPress2 = true;
               this.setData(EliteGameController.Instance.Model.topSixteen41_50,EliteGameController.Instance.Model.paarungRound41_50);
         }
      }
      
      protected function __dataReady(event:EliteGameEvent) : void
      {
         this.setType(this._btnGroup.selectIndex);
      }
      
      public function setData(topSixteen:Vector.<EliteGameTopSixteenInfo>, value:DictionaryData) : void
      {
         var index:String = null;
         this._topSixteen = topSixteen;
         this._paarungRound = value;
         if(Boolean(this._protrait))
         {
            this._protrait.visible = false;
         }
         this.emptyText();
         if(Boolean(this._paarungRound))
         {
            for(index in this._paarungRound)
            {
               this.addText(index,this._paarungRound[index]);
            }
         }
      }
      
      private function emptyText() : void
      {
         var index:String = null;
         var i:int = 0;
         for(index in this._texts)
         {
            for(i = 0; i < this._texts[index].length; i++)
            {
               this._texts[index][i].text = "";
            }
         }
      }
      
      private function clearTexts() : void
      {
         var index:String = null;
         var i:int = 0;
         for(index in this._texts)
         {
            for(i = 0; i < this._texts[index].length; i++)
            {
               ObjectUtils.disposeObject(this._texts[index][i]);
               this._texts[index][i] = null;
            }
            this._texts[index] = null;
         }
         this._texts = null;
      }
      
      private function addText(round:String, value:Vector.<int>) : void
      {
         var i:int = 0;
         var j:int = 0;
         if(round == "5")
         {
            if(this._protrait == null)
            {
               this._protrait = ComponentFactory.Instance.creatCustomObject("ddteliteGame.GiftBannerPortrait",["right"]);
               addToContent(this._protrait);
            }
            this._protrait.visible = true;
            this._playerInfo = PlayerManager.Instance.findPlayer(value[0]);
            if(this._playerInfo.Style == null)
            {
               SocketManager.Instance.out.sendItemEquip(value[0],false);
               this._playerInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__infoHandler);
            }
            else
            {
               this._protrait.info = this._playerInfo;
            }
            this._texts["5"][0].htmlText = "<a href=\"event:\">" + this.getNameWithId(value[0]) + "</a>";
            this._texts["5"][0].playerId = value[0];
         }
         else
         {
            for(i = 0; i < value.length; i++)
            {
               for(j = 0; j < this._texts[round].length; j++)
               {
                  if(Boolean(this._texts[round][j].canAccept(this.getRankWithId(value[i]))))
                  {
                     this._texts[round][j].htmlText = "<a href=\"event:\">" + this.getNameWithId(value[i]) + "</a>";
                     this._texts[round][j].playerId = value[i];
                     break;
                  }
               }
            }
         }
      }
      
      protected function __infoHandler(event:PlayerPropertyEvent) : void
      {
         this._playerInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__infoHandler);
         this._protrait.info = this._playerInfo;
      }
      
      private function getRankWithId(id:int) : int
      {
         for(var i:int = 0; i < this._topSixteen.length; i++)
         {
            if(id == this._topSixteen[i].id)
            {
               return this._topSixteen[i].rank;
            }
         }
         return 0;
      }
      
      private function getNameWithId(id:int) : String
      {
         for(var i:int = 0; i < this._topSixteen.length; i++)
         {
            if(id == this._topSixteen[i].id)
            {
               return this._topSixteen[i].name;
            }
         }
         return "";
      }
      
      override public function dispose() : void
      {
         EliteGameController.Instance.removeEventListener(EliteGameEvent.TOP_SIXTEEN_READY,this.__dataReady);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         removeEventListener(FrameEvent.RESPONSE,this.__responsehandler);
         if(Boolean(this._tilteBmp))
         {
            ObjectUtils.disposeObject(this._tilteBmp);
         }
         this._tilteBmp = null;
         if(Boolean(this._bigBg))
         {
            ObjectUtils.disposeObject(this._bigBg);
         }
         this._bigBg = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._tip1))
         {
            ObjectUtils.disposeObject(this._tip1);
         }
         this._tip1 = null;
         if(Boolean(this._tip2))
         {
            ObjectUtils.disposeObject(this._tip2);
         }
         this._tip2 = null;
         if(Boolean(this._tip3))
         {
            ObjectUtils.disposeObject(this._tip3);
         }
         this._tip3 = null;
         if(Boolean(this._tip4))
         {
            ObjectUtils.disposeObject(this._tip4);
         }
         this._tip4 = null;
         if(Boolean(this._between30_40))
         {
            ObjectUtils.disposeObject(this._between30_40);
         }
         this._between30_40 = null;
         if(Boolean(this._between41_50))
         {
            ObjectUtils.disposeObject(this._between41_50);
         }
         this._between41_50 = null;
         this.clearTexts();
         this._texts = null;
         this._topSixteen = null;
         this._paarungRound = null;
         super.dispose();
      }
   }
}

