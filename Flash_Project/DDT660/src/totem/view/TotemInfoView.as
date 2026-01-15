package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import totem.TotemManager;
   
   public class TotemInfoView extends Sprite implements Disposeable
   {
      
      private var _windowView:TotemLeftWindowView;
      
      private var _levelBg:Bitmap;
      
      private var _level:FilterFrameText;
      
      private var _txtBg:Bitmap;
      
      private var _propertyList:Vector.<TotemInfoViewTxtCell>;
      
      private var _info:PlayerInfo;
      
      public function TotemInfoView(info:PlayerInfo)
      {
         super();
         this._info = info;
         this.initView();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var tmp:TotemInfoViewTxtCell = null;
         this._windowView = ComponentFactory.Instance.creatCustomObject("totemInfoWindowView");
         this._windowView.show(TotemManager.instance.getCurInfoById(this._info.totemId).Page,TotemManager.instance.getNextInfoById(this._info.totemId),false);
         this._windowView.scaleX = 435 / 549;
         this._windowView.scaleY = 435 / 549;
         this._windowView.scalePropertyTxtSprite(549 / 435);
         this._levelBg = ComponentFactory.Instance.creatBitmap("asset.totem.infoView.levelBg");
         this._level = ComponentFactory.Instance.creatComponentByStylename("totem.infoView.level.txt");
         this._txtBg = ComponentFactory.Instance.creatBitmap("asset.totem.infoView.txtBg");
         addChild(this._windowView);
         addChild(this._levelBg);
         addChild(this._level);
         this._level.text = TotemManager.instance.getCurrentLv(TotemManager.instance.getTotemPointLevel(this._info.totemId)).toString();
         addChild(this._txtBg);
         this._propertyList = new Vector.<TotemInfoViewTxtCell>();
         for(i = 1; i <= 7; i++)
         {
            tmp = ComponentFactory.Instance.creatCustomObject("TotemInfoViewTxtCell" + i);
            tmp.show(i,TotemManager.instance.getTotemPointLevel(this._info.totemId));
            addChild(tmp);
            this._propertyList.push(tmp);
            tmp.x = this._propertyList[0].x + (i - 1) % 4 * 104;
            tmp.y = this._propertyList[0].y + int((i - 1) / 4) * 32;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._windowView = null;
         this._levelBg = null;
         this._level = null;
         this._txtBg = null;
         this._propertyList = null;
         this._info = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

