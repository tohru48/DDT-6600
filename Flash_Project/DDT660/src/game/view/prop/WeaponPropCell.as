package game.view.prop
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.PropInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   
   public class WeaponPropCell extends PropCell
   {
      
      private var _countField:FilterFrameText;
      
      public function WeaponPropCell(shortcutKey:String, mode:int)
      {
         super(shortcutKey,mode);
         this.setGrayFilter();
      }
      
      private static function creatDeputyWeaponIcon(templateId:int) : Bitmap
      {
         switch(templateId)
         {
            case EquipType.Angle:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop29Asset");
            case EquipType.TrueAngle:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop30Asset");
            case EquipType.ExllenceAngle:
            case EquipType.ExllenceAngleI:
            case EquipType.ExllenceAngleII:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop35Asset");
            case EquipType.FlyAngle:
            case EquipType.FlyAngleI:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop36Asset");
            case EquipType.TrueShield:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop31Asset");
            case EquipType.ExcellentShield:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop32Asset");
            case EquipType.WishKingBlessing:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop41Asset");
            case EquipType.MagicBook:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop42Asset");
            case EquipType.GoldenFootball:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop50Asset");
            case EquipType.football:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop50Asset");
            case EquipType.CaptainShield:
               return ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop17012Asset");
            default:
               return null;
         }
      }
      
      override public function setPossiton(x:int, y:int) : void
      {
         super.setPossiton(x,y);
         this.x = _x;
         this.y = _y;
      }
      
      override protected function drawLayer() : void
      {
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this._countField = ComponentFactory.Instance.creatComponentByStylename("game.PropCell.CountField");
         addChild(this._countField);
      }
      
      public function setCount(count:int) : void
      {
         this._countField.text = count.toString();
         this._countField.x = _back.width - this._countField.width;
         this._countField.y = _back.height - this._countField.height;
      }
      
      override public function set info(val:PropInfo) : void
      {
         var asset:DisplayObject = null;
         var bitmap:Bitmap = null;
         ShowTipManager.Instance.removeTip(this);
         _info = val;
         asset = _asset;
         if(_info != null)
         {
            if(_info.Template.CategoryID != EquipType.OFFHAND && _info.Template.CategoryID != EquipType.TEMP_OFFHAND)
            {
               bitmap = ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop" + _info.Template.Pic + "Asset");
            }
            else
            {
               bitmap = creatDeputyWeaponIcon(_info.TemplateID);
            }
            if(Boolean(bitmap))
            {
               bitmap.smoothing = true;
               bitmap.x = bitmap.y = 3;
               bitmap.width = bitmap.height = 32;
               addChildAt(bitmap,getChildIndex(_fore));
            }
            _asset = bitmap;
            _tipInfo.info = _info.Template;
            _tipInfo.shortcutKey = _shortcutKey;
            ShowTipManager.Instance.addTip(this);
            buttonMode = true;
         }
         else
         {
            this._countField.text = "";
            buttonMode = false;
         }
         if(asset != null)
         {
            ObjectUtils.disposeObject(asset);
            asset = null;
         }
         this._countField.visible = _info != null || _asset != null;
      }
      
      override public function useProp() : void
      {
         if(Boolean(_info) || Boolean(_asset))
         {
            dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._countField);
         this._countField = null;
         super.dispose();
      }
   }
}

