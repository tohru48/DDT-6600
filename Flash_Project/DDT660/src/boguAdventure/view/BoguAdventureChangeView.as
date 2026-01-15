package boguAdventure.view
{
   import bagAndInfo.cell.CellContentCreator;
   import boguAdventure.BoguAdventureControl;
   import boguAdventure.model.BoguAdventureActionType;
   import boguAdventure.player.BoguAdventurePlayer;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.SoundManager;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class BoguAdventureChangeView extends Sprite implements Disposeable
   {
      
      public static const MINE:String = "mine";
      
      public static const SIGN:String = "sign";
      
      private var _bogu:BoguAdventurePlayer;
      
      private var _control:BoguAdventureControl;
      
      private var _list:Dictionary;
      
      private var _move:Boolean;
      
      private var _explodeAction:MovieClip;
      
      private var _awardAction:MovieClip;
      
      private var _mineNum:ScaleFrameImage;
      
      private var _awardImgae:CellContentCreator;
      
      private var _boguDie:Bitmap;
      
      public function BoguAdventureChangeView(control:BoguAdventureControl)
      {
         super();
         this._control = control;
         this.init();
      }
      
      private function init() : void
      {
         this._list = new Dictionary();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.createBogu();
         this.initEvent();
      }
      
      public function boguWalk(path:Array) : void
      {
         this.clearWarnAction();
         this._bogu.playerWalk(path);
         this._control.isMove = true;
         this._move = true;
      }
      
      public function placeGoods(type:String, index:int, indexPos:Point) : void
      {
         var goods:Bitmap = null;
         var key:String = index.toString();
         if(this._list[key] != null)
         {
            return;
         }
         goods = UICreatShortcut.creatAndAdd("boguAdventure.mapView." + type,this);
         goods.x = indexPos.x;
         goods.y = indexPos.y;
         if(Boolean(this._mineNum))
         {
            swapChildren(this._mineNum,goods);
         }
         this.changeShowLevel(getChildIndex(this._bogu));
         this._list[key] = goods;
      }
      
      public function celarGoods(index:int) : void
      {
         var key:String = index.toString();
         if(this._list[key] == null)
         {
            return;
         }
         var sign:Bitmap = this._list[key] as Bitmap;
         ObjectUtils.disposeObject(sign);
         sign = null;
         delete this._list[key];
      }
      
      public function playExplodAciton() : void
      {
         if(Boolean(this._explodeAction))
         {
            return;
         }
         this._explodeAction = UICreatShortcut.creatAndAdd("boguAdventure.view.explodeAction",this);
         this._explodeAction.stop();
         this._explodeAction.x = this._bogu.x + this._bogu.focusPos.x;
         this._explodeAction.y = this._bogu.y - 11;
         this._bogu.sceneCharacterActionType = BoguAdventurePlayer.WEEP;
         this.changeShowLevel(getChildIndex(this._bogu));
         this._explodeAction.play();
         this._explodeAction.addEventListener(Event.ENTER_FRAME,this.__onPlayExplodAcitonComplete);
         SoundManager.instance.play("069");
      }
      
      public function playAwardAction(templateId:int) : void
      {
         if(Boolean(this._awardImgae))
         {
            return;
         }
         this._awardImgae = new CellContentCreator();
         this._awardImgae.info = ItemManager.Instance.getTemplateById(templateId);
         this._awardImgae.loadSync(this.onCreateAwardImageComplete);
      }
      
      public function playWarnAction(value:int, pos:Point) : void
      {
         this.clearWarnAction();
         if(!this._mineNum && value > 0)
         {
            this._mineNum = UICreatShortcut.creatAndAdd("boguAdventure.view.mineNum",this);
            this._mineNum.setFrame(value);
            this._mineNum.x = pos.x;
            this._mineNum.y = pos.y;
            addChild(this._mineNum);
         }
      }
      
      public function update() : void
      {
         if(Boolean(this._bogu))
         {
            this._bogu.update();
         }
         if(this._move)
         {
            this.changeShowLevel(getChildIndex(this._bogu));
         }
      }
      
      public function resetBogu(pos:Point) : void
      {
         this._move = false;
         this._control.isMove = false;
         this._bogu.dir = SceneCharacterDirection.RB;
         this._bogu.x = pos.x;
         this._bogu.y = pos.y;
         addChild(this._bogu);
      }
      
      public function clearChangeView() : void
      {
         var key:String = null;
         for(key in this._list)
         {
            ObjectUtils.disposeObject(this._list[key] as Bitmap);
            this._list[key] = null;
            delete this._list[key];
         }
         this._list = new Dictionary();
      }
      
      private function __onPlayExplodAcitonComplete(e:Event) : void
      {
         if(this._explodeAction.currentFrame == this._explodeAction.totalFrames)
         {
            this.clearExplodeAction();
            this._bogu.sceneCharacterActionType = BoguAdventurePlayer.STOP;
            this._control.playActionComplete({"type":BoguAdventureActionType.ACTINO_EXPLODE});
         }
      }
      
      private function clearExplodeAction() : void
      {
         if(Boolean(this._explodeAction))
         {
            this._explodeAction.stop();
            this._explodeAction.removeEventListener(Event.ENTER_FRAME,this.__onPlayExplodAcitonComplete);
            ObjectUtils.disposeAllChildren(this._explodeAction);
            ObjectUtils.disposeObject(this._explodeAction);
            this._explodeAction = null;
         }
      }
      
      private function onCreateAwardImageComplete() : void
      {
         if(Boolean(this._awardAction))
         {
            return;
         }
         this._awardAction = UICreatShortcut.creatAndAdd("boguAdventure.view.awardAction",this);
         this._awardAction.stop();
         this._awardImgae.height = 15;
         this._awardImgae.width = 15;
         this._awardAction["mc"].addChild(this._awardImgae);
         this._awardAction.x = this._bogu.x + this._bogu.focusPos.x - 133;
         this._awardAction.y = this._bogu.y;
         this._bogu.sceneCharacterActionType = BoguAdventurePlayer.LAUGH;
         this._awardAction.play();
         this._awardAction.addEventListener(Event.ENTER_FRAME,this.__onPlayAwardAcitonComplete);
      }
      
      private function __onPlayAwardAcitonComplete(e:Event) : void
      {
         if(this._awardAction.currentFrame == this._awardAction.totalFrames)
         {
            this.clearAwardAction();
            this._bogu.sceneCharacterActionType = BoguAdventurePlayer.STOP;
            this._control.playActionComplete({"type":BoguAdventureActionType.ACTION_AWARD});
         }
      }
      
      private function clearAwardAction() : void
      {
         if(Boolean(this._awardAction))
         {
            this._awardAction.stop();
            this._awardAction.removeEventListener(Event.ENTER_FRAME,this.__onPlayAwardAcitonComplete);
            ObjectUtils.disposeObject(this._awardImgae);
            this._awardImgae = null;
            ObjectUtils.disposeAllChildren(this._awardAction);
            ObjectUtils.disposeObject(this._awardAction);
            this._awardAction = null;
         }
      }
      
      public function clearWarnAction() : void
      {
         if(Boolean(this._mineNum))
         {
            ObjectUtils.disposeObject(this._mineNum);
            this._mineNum = null;
         }
      }
      
      public function boguState(value:Boolean) : void
      {
         ObjectUtils.disposeObject(this._boguDie);
         this._boguDie = null;
         if(value)
         {
            this._bogu.visible = true;
         }
         else
         {
            this._boguDie = UICreatShortcut.creatAndAdd("boguAdventure.view.die",this);
            if(this._bogu.dir == SceneCharacterDirection.LB)
            {
               this._boguDie.scaleX = -1;
            }
            else
            {
               this._boguDie.scaleX = 1;
            }
            this._boguDie.x = this._bogu.x;
            this._boguDie.y = this._bogu.y;
            this._bogu.visible = false;
         }
      }
      
      private function __onStopMove(e:SceneCharacterEvent) : void
      {
         if(!Boolean(e.data))
         {
            this._move = false;
            this._bogu.sceneCharacterActionType = BoguAdventurePlayer.STOP;
            this._control.walkComplete();
         }
         else
         {
            this._bogu.sceneCharacterActionType = BoguAdventurePlayer.WALK;
         }
      }
      
      private function createBogu() : void
      {
         this._bogu = new BoguAdventurePlayer(this.createBoguComplete);
         this._bogu.moveSpeed = 0.2;
         this._bogu.mouseChildren = false;
         this._bogu.mouseEnabled = false;
         addChild(this._bogu);
      }
      
      private function createBoguComplete(bogu:BoguAdventurePlayer, isLoadSucceed:Boolean, index:int = 0) : void
      {
         if(isLoadSucceed)
         {
            this._bogu.sceneCharacterActionType = BoguAdventurePlayer.STOP;
            this._control.bogu = this._bogu;
            return;
         }
         throw new Error("加载啵咕形象失败!检查下资源文件!");
      }
      
      private function changeShowLevel(index:int) : void
      {
         var obj2:DisplayObject = null;
         var obj1:DisplayObject = getChildAt(index);
         for each(obj2 in this._list)
         {
            this.swapShowLevel(getChildIndex(obj1),getChildIndex(obj2));
         }
      }
      
      private function swapShowLevel(index1:int, index2:int) : void
      {
         if(index1 == index2)
         {
            return;
         }
         var obj1:DisplayObject = getChildAt(index1);
         var obj2:DisplayObject = getChildAt(index2);
         if(Math.abs(obj1.x - obj2.x) < 150 && Math.abs(obj1.y - obj2.y) < 150)
         {
            if(obj1.y + obj1.height > obj2.y + obj2.height)
            {
               if(index1 < index2)
               {
                  this.swapChildrenAt(index1,index2);
               }
            }
            else if(index1 > index2)
            {
               this.swapChildrenAt(index1,index2);
            }
         }
      }
      
      private function initEvent() : void
      {
         this._bogu.addEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.__onStopMove);
      }
      
      private function removeEvent() : void
      {
         this._bogu.removeEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.__onStopMove);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clearAwardAction();
         this.clearExplodeAction();
         removeChild(this._bogu);
         this.clearChangeView();
         this.clearWarnAction();
         this._list = null;
         this._bogu.dispose();
         this._bogu = null;
         this._control = null;
         ObjectUtils.disposeObject(this._boguDie);
         this._boguDie = null;
         ObjectUtils.disposeAllChildren(this);
      }
   }
}

