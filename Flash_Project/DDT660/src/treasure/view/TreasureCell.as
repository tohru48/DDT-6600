package treasure.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   import treasure.controller.TreasureManager;
   import treasure.events.TreasureEvents;
   import treasure.model.TreasureModel;
   
   public class TreasureCell extends Sprite implements Disposeable
   {
      
      public var cell:TreasureFieldCell;
      
      private var _field:MovieClip;
      
      private var _tbxCount:FilterFrameText;
      
      public var cartoon:MovieClip;
      
      public var _fieldPos:int;
      
      private var cartoon_dig:MovieClip;
      
      private var cursor:Bitmap;
      
      public function TreasureCell(fieldPos:int, dis:Boolean = true)
      {
         super();
         this.cursor = ComponentFactory.Instance.creatBitmap("asset.treasure.cursor");
         this._fieldPos = fieldPos;
         this._field = ComponentFactory.Instance.creat("asset.treasure.field");
         if(TreasureModel.instance.itemList[this._fieldPos - 1].pos > 0)
         {
            this._field.gotoAndStop(2);
         }
         else
         {
            this._field.gotoAndStop(1);
         }
         this._field.alpha = 0;
         addChild(this._field);
         if(dis || TreasureModel.instance.itemList[this._fieldPos - 1].pos > 0)
         {
            this.creatCartoon();
         }
         addChild(this.cursor);
         this.cursor.visible = false;
      }
      
      public function creatCartoon(frame:String = "show") : void
      {
         var s:Sprite = null;
         if(Boolean(this.cartoon))
         {
            ObjectUtils.disposeObject(this.cartoon);
         }
         this.cartoon = null;
         if(frame == "end")
         {
            this.removeEvent();
            this.outHandler(new MouseEvent(MouseEvent.MOUSE_MOVE));
         }
         this.cartoon = ComponentFactory.Instance.creat("asset.treasure.cartoon1");
         s = new Sprite();
         s.graphics.beginFill(16777215,0);
         s.graphics.drawRect(0,0,78,78);
         s.graphics.endFill();
         this._tbxCount = ComponentFactory.Instance.creatComponentByStylename("treasure.CountText");
         this._tbxCount.mouseEnabled = false;
         PositionUtils.setPos(this._tbxCount,"treasure.cell.numTf.pos");
         this.cell = new TreasureFieldCell(s,TreasureModel.instance.itemList[this._fieldPos - 1]);
         this.cartoon.mc.addChild(this.cell);
         this.cartoon.mc.addChild(this._tbxCount);
         this.cartoon.gotoAndPlay(frame);
         if(frame == "end")
         {
            this.cartoon.addEventListener(Event.ENTER_FRAME,this.__allOverHandler);
         }
         this._tbxCount.text = String(TreasureModel.instance.itemList[this._fieldPos - 1].Count);
         PositionUtils.setPos(this.cell,"treasure.cell.pos");
         addChild(this.cartoon);
         this.cartoon.visible = true;
         PositionUtils.setPos(this.cartoon,"cartoon1.pos");
      }
      
      private function __allOverHandler(e:Event) : void
      {
         if(this.cartoon.currentFrame == this.cartoon.totalFrames)
         {
            this.cartoon.removeEventListener(Event.ENTER_FRAME,this.__allOverHandler);
            TreasureModel.instance.isClick = true;
            if(!TreasureModel.instance.isEndTreasure && PlayerManager.Instance.Self.treasure + PlayerManager.Instance.Self.treasureAdd == 0 && TreasureModel.instance.friendHelpTimes >= PathManager.treasureHelpTimes)
            {
               SocketManager.Instance.out.endTreasure();
            }
         }
      }
      
      public function removeCell() : void
      {
         if(Boolean(this.cartoon))
         {
            this.cartoon.mc.removeChild(this.cell);
            this.cartoon.mc.removeChild(this._tbxCount);
         }
      }
      
      public function digBackHandler() : void
      {
         this.removeEvent();
         this.outHandler(new MouseEvent(MouseEvent.MOUSE_MOVE));
         if(Boolean(this.cartoon_dig))
         {
            this.cartoon_dig.visible = true;
         }
         else
         {
            this.cartoon_dig = ComponentFactory.Instance.creat("asset.treasure.cartoon3");
            addChild(this.cartoon_dig);
         }
         PositionUtils.setPos(this.cartoon_dig,"cartoon3.pos");
         this.cartoon_dig.addEventListener(Event.ENTER_FRAME,this.cartoon_digHandler);
      }
      
      private function cartoon_digHandler(e:Event) : void
      {
         if(this.cartoon_dig.currentFrame == this.cartoon_dig.totalFrames)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.fightLib.Award.GetMessage") + TreasureModel.instance.itemList[this._fieldPos - 1].Name + "*" + String(TreasureModel.instance.itemList[this._fieldPos - 1].Count));
            this.cartoon_dig.removeEventListener(Event.ENTER_FRAME,this.cartoon_digHandler);
            this.cartoon_dig.visible = false;
            TreasureManager.instance.dispatchEvent(new TreasureEvents(TreasureEvents.FIELD_CHANGE,{"pos":this._fieldPos}));
            this.creatCartoon("end");
         }
      }
      
      private function removeEvent() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
      }
      
      public function addEvent() : void
      {
         if(TreasureModel.instance.itemList[this._fieldPos - 1].pos == 0 && TreasureModel.instance.isBeginTreasure && !TreasureModel.instance.isEndTreasure)
         {
            this.addEventListener(MouseEvent.CLICK,this.clickHandler);
            this.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
            this.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         }
      }
      
      private function overHandler(e:MouseEvent) : void
      {
         Mouse.hide();
         this.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
      }
      
      private function outHandler(e:MouseEvent) : void
      {
         Mouse.show();
         this.cursor.visible = false;
         this.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
      }
      
      private function mouseMoveHandler(event:MouseEvent) : void
      {
         this.cursor.x = event.localX;
         this.cursor.y = event.localY - 18;
         event.updateAfterEvent();
         this.cursor.visible = true;
      }
      
      private function clickHandler(e:MouseEvent) : void
      {
         if(TreasureModel.instance.isClick)
         {
            if(PlayerManager.Instance.Self.treasure + PlayerManager.Instance.Self.treasureAdd > 0)
            {
               TreasureModel.instance.isClick = false;
               this.mouseEnabled = false;
               SocketManager.Instance.out.doTreasure(this._fieldPos);
            }
            else if(TreasureModel.instance.friendHelpTimes < PathManager.treasureHelpTimes)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.treasure.warning"));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.treasure.warning1"));
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.treasure.warning1"));
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this.cell))
         {
            ObjectUtils.disposeObject(this.cell);
         }
         this.cell = null;
         if(Boolean(this._field))
         {
            ObjectUtils.disposeObject(this._field);
         }
         this._field = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

