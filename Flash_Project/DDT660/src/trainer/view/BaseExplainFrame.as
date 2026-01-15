package trainer.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import org.aswing.KeyboardManager;
   
   public class BaseExplainFrame extends Sprite implements Disposeable
   {
      
      public static const EXPLAIN_ENTER:String = "explainEnter";
      
      private var _bg:Bitmap;
      
      private var _bg1:MutipleImage;
      
      private var _bg2:MutipleImage;
      
      private var _bg3:ScaleBitmapImage;
      
      private var _bmpTitle:Bitmap;
      
      private var _btnEnter:BaseButton;
      
      public function BaseExplainFrame()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.core.bigbg");
         addChild(this._bg);
         this._bg1 = ComponentFactory.Instance.creat("trainer.explain.bg1");
         addChild(this._bg1);
         this._bg2 = ComponentFactory.Instance.creat("trainer.explain.bg2");
         addChild(this._bg2);
         this._bmpTitle = ComponentFactory.Instance.creatBitmap("asset.explain.title");
         addChild(this._bmpTitle);
         this._btnEnter = ComponentFactory.Instance.creat("trainer.explain.btnEnter");
         this._btnEnter.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         addChild(this._btnEnter);
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown,false,1000);
      }
      
      private function __clickHandler(evt:MouseEvent) : void
      {
         this._btnEnter.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         dispatchEvent(new Event(BaseExplainFrame.EXPLAIN_ENTER));
         SoundManager.instance.play("008");
      }
      
      private function __keyDown(evt:KeyboardEvent) : void
      {
         if(evt.keyCode == Keyboard.ENTER)
         {
            KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown,false);
            this.__clickHandler(null);
         }
      }
      
      public function dispose() : void
      {
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown,false);
         this._btnEnter.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._bg1 = null;
         this._bg2 = null;
         this._bg3 = null;
         this._bmpTitle = null;
         this._btnEnter = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

