package newOpenGuide
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.MainToolBar;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import hall.player.HallPlayerView;
   import trainer.data.Step;
   
   public class NewOpenGuideManager extends EventDispatcher
   {
      
      private static var _instance:NewOpenGuideManager;
      
      public const openLevelList:Array = [3,5,6,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,28,30];
      
      public const openMovePosList:Array = [new Point(662,144),new Point(399,169),new Point(0,0),new Point(635,6),new Point(219,96),new Point(445,-10),new Point(0,0),new Point(891,540),new Point(780,543),new Point(780,543),new Point(445,-10),new Point(780,543),new Point(445,-10),new Point(445,-10),new Point(445,-10),new Point(780,543),new Point(891,540),new Point(891,540),new Point(891,540),new Point(891,540),new Point(0,0),new Point(0,0),new Point(0,0),new Point(445,-10)];
      
      public const titleStrList:Array = LanguageMgr.GetTranslation("newOpenGuide.openTitleListStr").split(",");
      
      private var _rightView:NewOpenGuideRightView;
      
      private var _playerView:HallPlayerView;
      
      private var _dialog:NewOpenGuideDialogView;
      
      private var _coverSpriteInPlayCartoon:Sprite;
      
      public function NewOpenGuideManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : NewOpenGuideManager
      {
         if(_instance == null)
         {
            _instance = new NewOpenGuideManager();
         }
         return _instance;
      }
      
      public function getMovePos() : Point
      {
         var tmpPos:Point = null;
         var curLevel:int = PlayerManager.Instance.Self.Grade;
         var tmpLen:int = int(this.openLevelList.length);
         for(var i:int = 0; i < tmpLen; i++)
         {
            if(curLevel == this.openLevelList[i])
            {
               tmpPos = this.openMovePosList[i];
               if(tmpPos.x == 0 && tmpPos.y == 0)
               {
                  return MainToolBar.Instance.newBtnOpenCartoon();
               }
               return tmpPos;
            }
         }
         return new Point(445,-10);
      }
      
      public function getTitleStrIndexByLevel(level:int) : Array
      {
         var reArray:Array = [-1,"",-1];
         var titleStr:String = "";
         var tmpIndex:int = -1;
         var tmpLen:int = int(this.openLevelList.length);
         for(var i:int = 0; i < tmpLen; i++)
         {
            if(level == this.openLevelList[i])
            {
               titleStr = this.titleStrList[i];
               tmpIndex = i + 1;
               break;
            }
         }
         reArray[0] = tmpIndex;
         reArray[1] = titleStr;
         reArray[2] = level;
         return reArray;
      }
      
      public function closeShow() : void
      {
         this._playerView = null;
         ObjectUtils.disposeObject(this._rightView);
         this._rightView = null;
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      public function checkShow(playerView:HallPlayerView) : void
      {
         this._playerView = playerView;
         this._rightView = new NewOpenGuideRightView();
         this._rightView.x = 845;
         this._rightView.y = 140;
         LayerManager.Instance.addToLayer(this._rightView,LayerManager.GAME_UI_LAYER);
         this.judgeMiddleView();
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      private function __propertyChange(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["Grade"]))
         {
            if(Boolean(this._rightView))
            {
               this._rightView.refreshView();
            }
            this.judgeMiddleView();
         }
      }
      
      private function judgeMiddleView() : void
      {
         var tmp:Array = this.getTitleStrIndexByLevel(PlayerManager.Instance.Self.Grade);
         if(tmp[0] > 0 && !PlayerManager.Instance.Self.isNewOnceFinish(Step.NEW_OPEN_GUIDE_START + tmp[2]))
         {
            setTimeout(this.createOpenView,1000);
         }
      }
      
      private function createOpenCartoon() : void
      {
         var mc:MovieClip = null;
         mc = ComponentFactory.Instance.creat(this.getOpenCartoonClassName());
         mc.mouseChildren = false;
         mc.mouseEnabled = false;
         mc.addEventListener(Event.ENTER_FRAME,this.openCartoonPlayFrame);
         mc.gotoAndPlay(1);
         var tmpGrade:int = PlayerManager.Instance.Self.Grade;
         if(tmpGrade == 5 || tmpGrade == 15 || tmpGrade == 17 || tmpGrade == 18)
         {
            this._playerView.hallView.addChild(mc);
         }
         else
         {
            this._playerView.hallView[this.getBuildOrNpcName()].addChild(mc);
         }
      }
      
      private function openCartoonPlayFrame(event:Event) : void
      {
         var mc:MovieClip = event.currentTarget as MovieClip;
         if(mc.currentFrame == mc.totalFrames)
         {
            if(Boolean(mc.parent))
            {
               mc.parent.removeChild(mc);
            }
            mc.stop();
            mc.removeEventListener(Event.ENTER_FRAME,this.openCartoonPlayFrame);
            if(PlayerManager.Instance.Self.Grade >= 10)
            {
               this._playerView.mapID = 0;
               SocketManager.Instance.out.sendLoadOtherPlayer();
            }
            this._playerView.setCenter();
            if(Boolean(this._coverSpriteInPlayCartoon) && Boolean(this._coverSpriteInPlayCartoon.parent))
            {
               this._coverSpriteInPlayCartoon.parent.removeChild(this._coverSpriteInPlayCartoon);
            }
            this._coverSpriteInPlayCartoon = null;
         }
      }
      
      private function createOpenView() : void
      {
         var middleView:NewOpenGuideMiddleView = new NewOpenGuideMiddleView();
         middleView.addEventListener(Event.COMPLETE,this.middleViewCompleteHandler);
         LayerManager.Instance.addToLayer(middleView,LayerManager.STAGE_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function middleViewCompleteHandler(event:Event) : void
      {
         var tmpPos:Point = null;
         var selfPos:Point = null;
         var delay:Number = NaN;
         var tmp:NewOpenGuideMiddleView = event.currentTarget as NewOpenGuideMiddleView;
         tmp.removeEventListener(Event.COMPLETE,this.middleViewCompleteHandler);
         var level:int = PlayerManager.Instance.Self.Grade;
         if(this.isHasOpenCartoon())
         {
            this._coverSpriteInPlayCartoon = new Sprite();
            this._coverSpriteInPlayCartoon.graphics.beginFill(0,0);
            this._coverSpriteInPlayCartoon.graphics.drawRect(-500,-300,2000,1200);
            this._coverSpriteInPlayCartoon.graphics.endFill();
            LayerManager.Instance.addToLayer(this._coverSpriteInPlayCartoon,LayerManager.STAGE_TOP_LAYER);
            if(level > 10)
            {
               tmpPos = this.getMapMovePos();
               if(Boolean(tmpPos))
               {
                  selfPos = this._playerView.getSelfPlayerPos();
                  delay = Math.abs(tmpPos.x - selfPos.x) / 1000;
                  this._playerView.moveBgToTargetPos(tmpPos.x,tmpPos.y,delay);
                  setTimeout(this.createOpenCartoon,delay * 1000);
               }
            }
            else
            {
               this.createOpenCartoon();
            }
         }
         this.disposeDialogView();
         if(level == 3 || level == 5 || level == 6 || level == 10)
         {
            this._dialog = new NewOpenGuideDialogView();
            if(level == 3)
            {
               this._dialog.show(LanguageMgr.GetTranslation("newOpenGuide.roomListOpenPrompt"));
            }
            else if(level == 5)
            {
               this._dialog.show(LanguageMgr.GetTranslation("newOpenGuide.storeOpenPrompt"));
            }
            else if(level == 6)
            {
               this._dialog.show(LanguageMgr.GetTranslation("newOpenGuide.reFight"));
            }
            else if(level == 10)
            {
               this._dialog.show(LanguageMgr.GetTranslation("newOpenGuide.crossDoorPrompt"));
            }
            LayerManager.Instance.addToLayer(this._dialog,LayerManager.STAGE_TOP_LAYER);
            setTimeout(this.disposeDialogView,4000);
         }
      }
      
      private function disposeDialogView() : void
      {
         ObjectUtils.disposeObject(this._dialog);
         this._dialog = null;
      }
      
      private function getBuildOrNpcName() : String
      {
         var tmpGrade:int = PlayerManager.Instance.Self.Grade;
         switch(tmpGrade)
         {
            case 3:
               return "roomList";
            case 5:
               return "store";
            case 10:
               return "dungeon";
            case 15:
               return "church";
            case 17:
               return "constrion";
            case 18:
               return "auction";
            case 19:
               return "ringStation";
            case 30:
               return "labyrinth";
            default:
               return "roomList";
         }
      }
      
      private function isHasOpenCartoon() : Boolean
      {
         var tmpGrade:int = PlayerManager.Instance.Self.Grade;
         return tmpGrade == 3 || tmpGrade == 5 || tmpGrade == 10 || tmpGrade == 15 || tmpGrade == 17 || tmpGrade == 18 || tmpGrade == 19 || tmpGrade == 30;
      }
      
      private function getMapMovePos() : Point
      {
         var tmpGrade:int = PlayerManager.Instance.Self.Grade;
         switch(tmpGrade)
         {
            case 3:
               return new Point(0,0);
            case 5:
               return new Point(0,0);
            case 10:
               return new Point(-656,0);
            case 15:
               return new Point(-1792,0);
            case 17:
               return new Point(-819,0);
            case 18:
               return new Point(-1520,0);
            case 19:
               return new Point(-2239,0);
            case 30:
               return new Point(-2007,0);
            default:
               return new Point(0,0);
         }
      }
      
      private function getOpenCartoonClassName() : String
      {
         return "asset.newOpenGuide.openCartoon" + PlayerManager.Instance.Self.Grade;
      }
   }
}

