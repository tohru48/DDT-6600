package lottery.cell
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class LotteryBuffCell extends BaseCell
   {
      
      private var _timeLimit:ScaleFrameImage;
      
      private var _buffName:ScaleFrameImage;
      
      public function LotteryBuffCell()
      {
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,46,60);
         sp.graphics.endFill();
         super(sp);
         this.initII();
         this.addEvent();
      }
      
      private function initII() : void
      {
         this._timeLimit = ComponentFactory.Instance.creatComponentByStylename("lottery.buffCell.timeLimit");
         addChild(this._timeLimit);
         this._buffName = ComponentFactory.Instance.creatComponentByStylename("lottery.buffCell.buffName");
         addChild(this._buffName);
         PicPos = new Point(-3,-3);
      }
      
      private function addEvent() : void
      {
         addEventListener(Event.CHANGE,this.__infoChange);
      }
      
      private function __infoChange(evt:Event) : void
      {
         this._buffName.visible = true;
         switch(_info.TemplateID)
         {
            case EquipType.PREVENT_KICK:
               this._buffName.visible = false;
               break;
            case EquipType.DOUBLE_GESTE_CARD:
               this._buffName.setFrame(2);
               break;
            case EquipType.DOUBLE_EXP_CARD:
               this._buffName.setFrame(1);
               break;
            case EquipType.FREE_PROP_CARD:
               this._buffName.visible = false;
               break;
            default:
               this._buffName.visible = false;
         }
      }
      
      public function set timeLimit(value:int) : void
      {
         this._timeLimit.setFrame(value);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(Event.CHANGE,this.__infoChange);
         if(Boolean(this._buffName))
         {
            ObjectUtils.disposeObject(this._buffName);
         }
         this._buffName = null;
         if(Boolean(this._timeLimit))
         {
            ObjectUtils.disposeObject(this._timeLimit);
         }
         this._timeLimit = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

