package ringStation.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.GameManager;
   import ringStation.RingStationManager;
   import ringStation.event.RingStationEvent;
   import road7th.comm.PackageIn;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class RingStationView extends Frame
   {
      
      private static var CHALLENGEPERSON_NUM:int = 4;
      
      private var _titleBitmap:Bitmap;
      
      private var _frameBottom:ScaleBitmapImage;
      
      private var _helpBtn:BaseButton;
      
      private var _userView:StationUserView;
      
      private var _challengeVec:Vector.<ChallengePerson>;
      
      private var _arrowSrite:Sprite;
      
      private var _nameArray:Array = new Array(LanguageMgr.GetTranslation("ringStation.view.person.name0"),LanguageMgr.GetTranslation("ringStation.view.person.name1"),LanguageMgr.GetTranslation("ringStation.view.person.name2"));
      
      public function RingStationView()
      {
         super();
         this.initView();
         this.initEvent();
         this.sendPkg();
      }
      
      private function initView() : void
      {
         var challengePerson:ChallengePerson = null;
         titleText = LanguageMgr.GetTranslation("ddt.ringstation.titleInfo");
         this._titleBitmap = ComponentFactory.Instance.creat("ringstation.view.title");
         addToContent(this._titleBitmap);
         this._frameBottom = ComponentFactory.Instance.creatComponentByStylename("ringstation.frameBottom");
         addToContent(this._frameBottom);
         this._helpBtn = ComponentFactory.Instance.creat("ringStation.view.helpBtn");
         addToContent(this._helpBtn);
         this._userView = new StationUserView();
         PositionUtils.setPos(this._userView,"ringStation.view.userViewPos");
         addToContent(this._userView);
         this._challengeVec = new Vector.<ChallengePerson>();
         for(var i:int = 0; i < CHALLENGEPERSON_NUM; i++)
         {
            challengePerson = new ChallengePerson();
            PositionUtils.setPos(challengePerson,"ringStation.challenge.personPos" + i);
            addToContent(challengePerson);
            this._challengeVec.push(challengePerson);
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__onHelpClick);
         SocketManager.Instance.addEventListener(RingStationEvent.RINGSTATION_VIEWINFO,this.__setViewInfo);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_1 = true;
      }
      
      protected function __onHelpClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpView:HelpView = ComponentFactory.Instance.creat("ringStation.helpView");
         LayerManager.Instance.addToLayer(helpView,LayerManager.STAGE_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __startLoading(e:Event) : void
      {
         StateManager.getInGame_Step_6 = true;
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
         StateManager.getInGame_Step_7 = true;
      }
      
      private function sendPkg() : void
      {
         SocketManager.Instance.out.sendRingStationGetInfo();
      }
      
      protected function __setViewInfo(event:RingStationEvent) : void
      {
         var j:int = 0;
         var l:int = 0;
         var m:int = 0;
         var k:int = 0;
         var pkg:PackageIn = event.pkg;
         var rankNum:int = pkg.readInt();
         this._userView.setRankNum(rankNum);
         this._userView.setChallengeNum(pkg.readInt());
         this._userView.buyCount = pkg.readInt();
         this._userView.buyPrice = pkg.readInt();
         var challgedate:Date = pkg.readDate();
         this._userView.setChallengeTime(challgedate);
         this._userView.cdPrice = pkg.readInt();
         pkg.readInt();
         var sign:String = pkg.readUTF();
         this._userView.setSignText(sign);
         this._userView.setAwardNum(pkg.readInt());
         this._userView.setAwardTime(pkg.readDate());
         this._userView.setChampionText(pkg.readUTF());
         if(rankNum == 0)
         {
            this._arrowSrite = new Sprite();
            addToContent(this._arrowSrite);
            NewHandContainer.Instance.showArrow(ArrowType.RING_STATION,45,"ringStation.view.challenge.arrowPos","","",this._arrowSrite,0,true);
         }
         var count:int = pkg.readInt();
         var playerVec:Vector.<PlayerInfo> = new Vector.<PlayerInfo>();
         var rankArray:Array = new Array();
         for(var i:int = 0; i < count; i++)
         {
            playerVec.push(this.readPersonInfo(pkg));
            rankArray.push(playerVec[i].Rank);
         }
         if(count == 1 && playerVec[0].Rank == 0)
         {
            this._challengeVec[0].updatePerson(playerVec[0]);
            for(j = 1; j < CHALLENGEPERSON_NUM; j++)
            {
               playerVec[0].NickName = this._nameArray[j - 1];
               this._challengeVec[j].updatePerson(playerVec[0]);
            }
         }
         else
         {
            rankArray.sort(Array.NUMERIC);
            for(l = 0; l < rankArray.length; l++)
            {
               for(k = 0; k < playerVec.length; k++)
               {
                  if(playerVec[k].Rank == rankArray[l])
                  {
                     this._challengeVec[l].updatePerson(playerVec[k]);
                  }
               }
            }
            for(m = count; m < this._challengeVec.length; m++)
            {
               this._challengeVec[m].setWaiting();
            }
         }
      }
      
      private function readPersonInfo(pkg:PackageIn) : PlayerInfo
      {
         var player:PlayerInfo = new PlayerInfo();
         player.ID = pkg.readInt();
         player.LoginName = pkg.readUTF();
         player.NickName = pkg.readUTF();
         player.typeVIP = pkg.readByte();
         player.VIPLevel = pkg.readInt();
         player.Grade = pkg.readInt();
         player.Sex = pkg.readBoolean();
         player.Style = pkg.readUTF();
         player.Colors = pkg.readUTF();
         player.Skin = pkg.readUTF();
         player.ConsortiaName = pkg.readUTF();
         player.Hide = pkg.readInt();
         player.Offer = pkg.readInt();
         player.WinCount = pkg.readInt();
         player.TotalCount = pkg.readInt();
         player.EscapeCount = pkg.readInt();
         player.Repute = pkg.readInt();
         player.Nimbus = pkg.readInt();
         player.GP = pkg.readInt();
         player.FightPower = pkg.readInt();
         player.AchievementPoint = pkg.readInt();
         player.Rank = pkg.readInt();
         player.WeaponID = pkg.readInt();
         player.signMsg = pkg.readUTF();
         return player;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__onHelpClick);
         SocketManager.Instance.removeEventListener(RingStationEvent.RINGSTATION_VIEWINFO,this.__setViewInfo);
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_8 = true;
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               RingStationManager.instance.hide();
         }
      }
      
      override public function dispose() : void
      {
         var i:int = 0;
         super.dispose();
         this.removeEvent();
         if(Boolean(this._titleBitmap))
         {
            this._titleBitmap = null;
         }
         if(Boolean(this._frameBottom))
         {
            this._frameBottom.dispose();
            this._frameBottom = null;
         }
         if(Boolean(this._helpBtn))
         {
            this._helpBtn.dispose();
            this._helpBtn = null;
         }
         if(Boolean(this._userView))
         {
            this._userView.dispose();
            this._userView = null;
         }
         if(Boolean(this._challengeVec))
         {
            for(i = 0; i < this._challengeVec.length; i++)
            {
               this._challengeVec[i].dispose();
               this._challengeVec[i] = null;
            }
            this._challengeVec.length = 0;
            this._challengeVec = null;
         }
         if(Boolean(this._arrowSrite))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.RING_STATION);
            this._arrowSrite = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

