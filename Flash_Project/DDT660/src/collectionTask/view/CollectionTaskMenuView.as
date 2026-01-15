package collectionTask.view
{
   import collectionTask.model.CollectionTaskModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CollectionTaskMenuView extends Sprite implements Disposeable
   {
      
      private var _menuShowName:ScaleFrameImage;
      
      private var _menuShowPao:ScaleFrameImage;
      
      private var _menuShowPlayer:ScaleFrameImage;
      
      private var _model:CollectionTaskModel;
      
      public function CollectionTaskMenuView(model:CollectionTaskModel)
      {
         super();
         this._model = model;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._menuShowName = ComponentFactory.Instance.creatComponentByStylename("collectionTask.menuShowNameAsset");
         this._menuShowName.buttonMode = true;
         this._menuShowName.setFrame(1);
         addChild(this._menuShowName);
         this._menuShowPao = ComponentFactory.Instance.creatComponentByStylename("collectionTask.menuShowPaoAsset");
         this._menuShowPao.buttonMode = true;
         this._menuShowPao.setFrame(1);
         addChild(this._menuShowPao);
         this._menuShowPlayer = ComponentFactory.Instance.creatComponentByStylename("collectionTask.menuShowPlayerAsset");
         this._menuShowPlayer.buttonMode = true;
         this._menuShowPlayer.setFrame(1);
         addChild(this._menuShowPlayer);
      }
      
      private function addEvent() : void
      {
         this._menuShowName.addEventListener(MouseEvent.CLICK,this.onMenuClick);
         this._menuShowPao.addEventListener(MouseEvent.CLICK,this.onMenuClick);
         this._menuShowPlayer.addEventListener(MouseEvent.CLICK,this.onMenuClick);
      }
      
      private function onMenuClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.currentTarget)
         {
            case this._menuShowName:
               if(this._menuShowName.getFrame == 1)
               {
                  this._menuShowName.setFrame(2);
                  this._model.playerNameVisible = false;
               }
               else
               {
                  this._menuShowName.setFrame(1);
                  this._model.playerNameVisible = true;
               }
               break;
            case this._menuShowPao:
               if(this._menuShowPao.getFrame == 1)
               {
                  this._menuShowPao.setFrame(2);
                  this._model.playerChatBallVisible = false;
               }
               else
               {
                  this._menuShowPao.setFrame(1);
                  this._model.playerChatBallVisible = true;
               }
               break;
            case this._menuShowPlayer:
               if(this._menuShowPlayer.getFrame == 1)
               {
                  this._menuShowPlayer.setFrame(2);
                  this._model.playerVisible = false;
               }
               else
               {
                  this._menuShowPlayer.setFrame(1);
                  this._model.playerVisible = true;
               }
         }
      }
      
      private function removeEvent() : void
      {
         this._menuShowName.removeEventListener(MouseEvent.CLICK,this.onMenuClick);
         this._menuShowPao.removeEventListener(MouseEvent.CLICK,this.onMenuClick);
         this._menuShowPlayer.removeEventListener(MouseEvent.CLICK,this.onMenuClick);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._menuShowName);
         this._menuShowName = null;
         ObjectUtils.disposeObject(this._menuShowPao);
         this._menuShowPao = null;
         ObjectUtils.disposeObject(this._menuShowPlayer);
         this._menuShowPlayer = null;
      }
   }
}

