package fightFootballTime.view
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   import com.pickgliss.ui.LayerManager;
   import ddt.events.GameEvent;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import game.GameManager;
   import game.model.GameInfo;
   import game.view.card.TakeOutCardController;
   import game.view.experience.ExpTweenManager;
   import game.view.experience.ExpView;
   import room.RoomManager;
   
   public class FightFootballTimeExpView extends ExpView
   {
      
      private var _leftView:FightFootballTimeExpLeftView;
      
      private var _gameInfo:GameInfo;
      
      private var _cardController:TakeOutCardController;
      
      private var _expObj:Object;
      
      private var _rightView:Sprite;
      
      private var _bg:Bitmap;
      
      private var _shape:Shape;
      
      public function FightFootballTimeExpView(bg:Bitmap = null)
      {
         super();
      }
      
      override public function show() : void
      {
         this._gameInfo = GameManager.Instance.Current;
         this._cardController = new TakeOutCardController();
         ExpTweenManager.Instance.isPlaying = true;
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
         this._rightView = new Sprite();
         PositionUtils.setPos(this._rightView,"fightFootballTime.expView.RightViewPos");
         if(Boolean(this._bg))
         {
            addChild(this._bg);
         }
         this.changeDark();
         addChild(this._rightView);
         this.leftView();
         ExpTweenManager.Instance.startTweens();
      }
      
      override public function showCard() : void
      {
         this._cardController.showSmallCardView = this.showSmallCardView;
         this._cardController.tryShowCard();
      }
      
      private function showSmallCardView(view:DisplayObject) : void
      {
         var addCardView:Function = null;
         addCardView = function():void
         {
            TweenMax.killTweensOf(_rightView);
            addChild(view);
         };
         if(Boolean(this._rightView))
         {
            TweenMax.to(this._rightView,0.4,{
               "x":"1000",
               "ease":Quint.easeOut,
               "onComplete":addCardView
            });
         }
         else
         {
            addCardView();
         }
      }
      
      private function showLargeCardView(view:DisplayObject) : void
      {
         var addCardView:Function = null;
         addCardView = function():void
         {
            TweenMax.killTweensOf(_rightView);
            TweenMax.killTweensOf(_leftView);
            addChild(view);
         };
         if(Boolean(this._rightView))
         {
            TweenMax.to(this._rightView,0.4,{
               "x":"1000",
               "ease":Quint.easeOut,
               "onComplete":addCardView
            });
         }
         else
         {
            addCardView();
         }
         if(Boolean(this._leftView))
         {
            TweenMax.to(this._leftView,0.4,{
               "x":"-1000",
               "ease":Quint.easeOut
            });
         }
      }
      
      private function onAllComplete() : void
      {
         ExpTweenManager.Instance.completeTweens();
         ExpTweenManager.Instance.deleteTweens();
         this._cardController.setup(this._gameInfo,RoomManager.Instance.current);
         this._cardController.disposeFunc = dispose;
         dispatchEvent(new GameEvent(GameEvent.EXPSHOWED,null));
      }
      
      private function fastComplete() : void
      {
         ExpTweenManager.Instance.speedRecover();
      }
      
      private function changeDark() : void
      {
         this._shape = new Shape();
         this._shape.graphics.beginFill(0,1);
         this._shape.graphics.drawRect(-2,-2,1002,602);
         this._shape.graphics.endFill();
         this._shape.alpha = 0;
         TweenMax.to(this._shape,0.5,{"alpha":0.8});
         addChild(this._shape);
      }
      
      private function leftView() : void
      {
         this._leftView = new FightFootballTimeExpLeftView();
         this._leftView.alpha = 0;
         addChild(this._leftView);
         ExpTweenManager.Instance.appendTween(TweenMax.to(this._leftView,0.5,{"alpha":1}));
      }
   }
}

