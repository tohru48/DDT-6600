package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class GuildRepute extends Sprite implements Disposeable
   {
      
      private var _reputeTxt:FilterFrameText;
      
      private var _reputeBg:Bitmap;
      
      public function GuildRepute()
      {
         super();
         this._reputeBg = ComponentFactory.Instance.creat("asset.core.leveltip.ReputeBg");
         var p:Point = ComponentFactory.Instance.creatCustomObject("asset.core.guildReputePos");
         this._reputeBg.x = p.x;
         this._reputeTxt = ComponentFactory.Instance.creat("core.guildReputeTxt");
         addChild(this._reputeBg);
         addChild(this._reputeTxt);
      }
      
      public function setRepute(re:int) : void
      {
         this._reputeTxt.text = String(re);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._reputeTxt))
         {
            ObjectUtils.disposeObject(this._reputeTxt);
         }
         this._reputeTxt = null;
         if(Boolean(this._reputeBg))
         {
            ObjectUtils.disposeObject(this._reputeBg);
         }
         this._reputeBg = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

