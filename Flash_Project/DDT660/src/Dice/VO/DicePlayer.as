package Dice.VO
{
   import Dice.Controller.DiceController;
   import Dice.Event.DiceEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.VipLevelIcon;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import vip.VipController;
   
   public class DicePlayer extends DicePlayerBase
   {
      
      private var _playerInfo:SelfInfo = PlayerManager.Instance.Self;
      
      private var _lblName:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _moveSpeedX:Number = 5;
      
      private var _moveSpeedY:Number = 4;
      
      private var _isShowName:Boolean = true;
      
      private var _propertyContainer:Sprite;
      
      private var _light:MovieClip;
      
      private var _isWalking:Boolean;
      
      public function DicePlayer(callBack:Function = null)
      {
         super(this._playerInfo,this.SynchronousPosition,callBack);
         this.preInitialize();
         this.initialize();
         this.addEvent();
      }
      
      public function get isWalking() : Boolean
      {
         return this._isWalking;
      }
      
      public function set isWalking(value:Boolean) : void
      {
         var proxy:Object = null;
         if(this._isWalking != value)
         {
            this._isWalking = value;
            proxy = new Object();
            proxy.isWalking = this._isWalking;
            DiceController.Instance.dispatchEvent(new DiceEvent(DiceEvent.PLAYER_ISWALKING,proxy));
            if(this._isWalking)
            {
               this._light.visible = false;
            }
            else
            {
               this._light.visible = true;
            }
         }
      }
      
      private function preInitialize() : void
      {
         this._propertyContainer = new Sprite();
         this._lblName = ComponentFactory.Instance.creatComponentByStylename("asset.dice.lblName");
         this._light = ComponentFactory.Instance.creat("asset.dice.destinationLight");
         PositionUtils.setPos(this._light,"asset.dice.playerlight.pos");
      }
      
      private function addEvent() : void
      {
         addEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.characterDirectionChange);
         addEventListener(Event.ENTER_FRAME,this.__update);
      }
      
      private function characterDirectionChange(evt:SceneCharacterEvent) : void
      {
         this.isWalking = Boolean(evt.data);
         if(this._isWalking)
         {
            if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
            {
               if(sceneCharacterStateType == "natural")
               {
                  character.scaleX = 1;
                  character.x = 0;
                  sceneCharacterActionType = "naturalWalkBack";
               }
            }
            else if(sceneCharacterDirection == SceneCharacterDirection.RB)
            {
               if(sceneCharacterStateType == "natural")
               {
                  character.scaleX = 1;
                  character.x = 0;
                  sceneCharacterActionType = "naturalWalkFront";
               }
            }
            else if(sceneCharacterDirection.type == "LB")
            {
               if(sceneCharacterStateType == "natural")
               {
                  if(sceneCharacterDirection.isMirror)
                  {
                     sceneCharacterActionType = "naturalWalkFront";
                     character.scaleX = -1;
                     character.x = _playerWidth;
                  }
                  else
                  {
                     character.scaleX = 1;
                     character.x = 0;
                     sceneCharacterActionType = "naturalWalkFront";
                  }
               }
            }
         }
         else if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
         {
            if(sceneCharacterStateType == "natural")
            {
               character.scaleX = 1;
               character.x = 0;
               sceneCharacterActionType = "naturalStandBack";
            }
         }
         else if(sceneCharacterDirection == SceneCharacterDirection.RB)
         {
            if(sceneCharacterStateType == "natural")
            {
               character.scaleX = 1;
               character.x = 0;
               sceneCharacterActionType = "naturalStandFront";
            }
         }
         else if(sceneCharacterDirection.type == "LB")
         {
            if(sceneCharacterStateType == "natural")
            {
               if(sceneCharacterDirection.isMirror)
               {
                  character.scaleX = -1;
                  character.x = _playerWidth;
                  sceneCharacterActionType = "naturalStandFront";
               }
               else
               {
                  character.scaleX = 1;
                  character.x = 0;
                  sceneCharacterActionType = "naturalStandFront";
               }
            }
         }
      }
      
      private function __update(event:Event) : void
      {
         if(Boolean(character))
         {
            update();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__update);
         removeEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.characterDirectionChange);
      }
      
      private function initialize() : void
      {
         mouseEnabled = false;
         mouseChildren = false;
         addChildAt(this._propertyContainer,0);
         addChild(this._light);
         this._lblName.text = Boolean(this._playerInfo) && Boolean(this._playerInfo.NickName) ? this._playerInfo.NickName : "";
         this._lblName.textColor = 6029065;
         if(this._playerInfo.IsVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(-1,this._playerInfo.typeVIP);
            this._vipName.x = this._lblName.x;
            this._vipName.y = this._lblName.y;
            this._vipName.text = this._lblName.text;
            this._vipIcon = ComponentFactory.Instance.creatCustomObject("asset.dic.VipIcon");
            this._vipIcon.setInfo(this._playerInfo);
            this._propertyContainer.addChild(this._vipName);
            this._propertyContainer.addChild(this._vipIcon);
            this._vipName.visible = this._vipIcon.visible = this._isShowName;
            this._lblName.dispose();
            this._lblName = null;
         }
         else
         {
            this._propertyContainer.addChild(this._lblName);
            this._lblName.visible = this._isShowName;
         }
      }
      
      private function SynchronousPosition(value:Point) : void
      {
      }
      
      public function PlayerWalkByPosition(start:int, end:int) : void
      {
         var path:Array = [];
         if(start < 0 || start >= DiceController.Instance.CELL_COUNT)
         {
            return;
         }
         if(end == 0 && !DiceController.Instance.hasUsedFirstCell)
         {
            end = 1;
         }
         path.push(this.GetCoordinatesByPosition(start));
         while(start != end)
         {
            start = ++start % DiceController.Instance.CELL_COUNT;
            path.push(this.GetCoordinatesByPosition(start));
         }
         playerWalk(path);
      }
      
      public function GetCoordinatesByPosition(value:int) : Point
      {
         if(value < 0)
         {
            value = 0;
         }
         else if(value >= DiceController.Instance.CELL_COUNT)
         {
            value = DiceController.Instance.CELL_COUNT - 1;
         }
         if(DiceController.Instance.cellPosition == null)
         {
            DiceController.Instance.setCellInfo();
         }
         return (DiceController.Instance.cellPosition[value] as DiceCellInfo).CellCenterPosition;
      }
      
      public function set CurrentPosition(value:int) : void
      {
         var pt:Point = null;
         pt = this.GetCoordinatesByPosition(value);
         x = pt.x;
         y = pt.y;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._lblName);
         this._lblName = null;
         ObjectUtils.disposeObject(this._vipName);
         this._vipName = null;
         ObjectUtils.disposeObject(this._vipIcon);
         this._vipIcon = null;
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

