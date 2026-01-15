package civil.view
{
   import civil.CivilController;
   import civil.CivilModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class CivilView extends Sprite implements Disposeable
   {
      
      private var _civilBg:MovieClip;
      
      private var _civilLeftView:CivilLeftView;
      
      private var _civilRightView:CivilRightView;
      
      private var _controller:CivilController;
      
      private var _model:CivilModel;
      
      private var _chatFrame:Sprite;
      
      private var _titleBg:ScaleFrameImage;
      
      private var _titleText:Bitmap;
      
      public function CivilView(controller:CivilController, model:CivilModel)
      {
         super();
         this._controller = controller;
         this._model = model;
         this.init();
      }
      
      private function init() : void
      {
         this._civilBg = ClassUtils.CreatInstance("asset.ddtcivil.Bg") as MovieClip;
         PositionUtils.setPos(this._civilBg,"ddtcivil.bgPos");
         addChild(this._civilBg);
         this._civilLeftView = new CivilLeftView(this._controller,this._model);
         this._civilRightView = new CivilRightView(this._controller,this._model);
         ChatManager.Instance.state = ChatManager.CHAT_CIVIL_VIEW;
         this._chatFrame = ChatManager.Instance.view;
         addChild(this._civilLeftView);
         addChild(this._civilRightView);
         addChild(this._chatFrame);
         this._titleBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.titleBgImg");
         this._titleText = ComponentFactory.Instance.creatBitmap("asset.ddtcivil.titleText");
         addChild(this._titleBg);
         addChild(this._titleText);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._civilBg))
         {
            ObjectUtils.disposeObject(this._civilBg);
            this._civilBg = null;
         }
         if(Boolean(this._civilLeftView))
         {
            ObjectUtils.disposeObject(this._civilLeftView);
            this._civilLeftView = null;
         }
         if(Boolean(this._civilRightView))
         {
            ObjectUtils.disposeObject(this._civilRightView);
            this._civilRightView = null;
         }
         if(Boolean(this._titleBg))
         {
            ObjectUtils.disposeObject(this._titleBg);
            this._titleBg = null;
         }
         if(Boolean(this._titleText))
         {
            ObjectUtils.disposeObject(this._titleText);
            this._titleText = null;
         }
         this._chatFrame = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

