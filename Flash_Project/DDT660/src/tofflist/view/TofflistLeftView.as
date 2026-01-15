package tofflist.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TofflistLeftView extends Sprite implements Disposeable
   {
      
      private var _chatFrame:Sprite;
      
      private var _currentPlayer:TofflistLeftCurrentCharcter;
      
      private var _bg1:MovieClip;
      
      private var _bg2:Bitmap;
      
      private var _lightsMc:MovieClip;
      
      public function TofflistLeftView()
      {
         super();
         this.init();
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._currentPlayer = null;
         if(Boolean(this._bg1))
         {
            ObjectUtils.disposeObject(this._bg1);
         }
         if(Boolean(this._bg2))
         {
            ObjectUtils.disposeObject(this._bg2);
         }
         if(Boolean(this._lightsMc))
         {
            ObjectUtils.disposeObject(this._lightsMc);
         }
         if(Boolean(this._chatFrame))
         {
            ObjectUtils.disposeObject(this._chatFrame);
         }
         this._bg1 = null;
         this._bg2 = null;
         this._lightsMc = null;
         this._chatFrame = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function init() : void
      {
         this._bg1 = ComponentFactory.Instance.creat("asset.background.tofflist.left");
         addChild(this._bg1);
         this._bg2 = ComponentFactory.Instance.creatBitmap("toffilist.leftImgBg");
         addChild(this._bg2);
         this._currentPlayer = new TofflistLeftCurrentCharcter();
         addChild(this._currentPlayer);
         this._lightsMc = ComponentFactory.Instance.creat("asset.LightsMcAsset");
         this._lightsMc.x = 6;
         this._lightsMc.y = 14;
         addChild(this._lightsMc);
         ChatManager.Instance.state = ChatManager.CHAT_TOFFLIST_VIEW;
         this._chatFrame = ChatManager.Instance.view;
         addChild(this._chatFrame);
      }
   }
}

