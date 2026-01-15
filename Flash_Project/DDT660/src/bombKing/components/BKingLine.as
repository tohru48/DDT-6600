package bombKing.components
{
   import bombKing.data.BKingPlayerInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class BKingLine extends Sprite implements Disposeable
   {
      
      private var _darkLine:Bitmap;
      
      private var _lightLine:Bitmap;
      
      private var _place:int;
      
      public function BKingLine(place:int)
      {
         super();
         this._place = place;
         this.initView();
      }
      
      private function initView() : void
      {
         switch(this._place)
         {
            case 2:
            case 3:
               this._darkLine = ComponentFactory.Instance.creat("bombKing.leftRightDark");
               this._lightLine = ComponentFactory.Instance.creat("bombKing.leftRightLight");
               break;
            case 4:
            case 5:
            case 6:
            case 7:
               this._darkLine = ComponentFactory.Instance.creat("bombKing.upDownDark");
               this._lightLine = ComponentFactory.Instance.creat("bombKing.upDownLight");
               break;
            case 8:
            case 10:
               this._darkLine = ComponentFactory.Instance.creat("bombKing.downLeftDark");
               this._lightLine = ComponentFactory.Instance.creat("bombKing.downLeftLight");
               break;
            case 9:
            case 11:
               this._darkLine = ComponentFactory.Instance.creat("bombKing.upLeftDark");
               this._lightLine = ComponentFactory.Instance.creat("bombKing.upLeftLight");
               break;
            case 12:
            case 14:
               this._darkLine = ComponentFactory.Instance.creat("bombKing.downRightDark");
               this._lightLine = ComponentFactory.Instance.creat("bombKing.downRightLight");
               break;
            case 13:
            case 15:
               this._darkLine = ComponentFactory.Instance.creat("bombKing.upRightDark");
               this._lightLine = ComponentFactory.Instance.creat("bombKing.upRightLight");
               break;
            default:
               this._darkLine = ComponentFactory.Instance.creat("bombKing.leftRightDark");
               this._lightLine = ComponentFactory.Instance.creat("bombKing.leftRightLight");
         }
         addChild(this._darkLine);
         addChild(this._lightLine);
         this._lightLine.visible = false;
      }
      
      public function set info(info:BKingPlayerInfo) : void
      {
         if(Boolean(info) && info.status == 1)
         {
            this._lightLine.visible = true;
            this._darkLine.visible = false;
         }
         else
         {
            this._lightLine.visible = false;
            this._darkLine.visible = true;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._darkLine);
         this._darkLine = null;
         ObjectUtils.disposeObject(this._lightLine);
         this._lightLine = null;
      }
   }
}

