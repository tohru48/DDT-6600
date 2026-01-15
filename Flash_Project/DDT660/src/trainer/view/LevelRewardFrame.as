package trainer.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.TaskManager;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ShowCharacter;
   import flash.display.Bitmap;
   import flash.geom.Point;
   import trainer.TrainStep;
   import trainer.controller.WeakGuildManager;
   
   public class LevelRewardFrame extends BaseAlerFrame
   {
      
      private var _bg:MutipleImage;
      
      private var _playerView:ShowCharacter;
      
      private var _up:MutipleImage;
      
      private var _item1:LevelRewardItem;
      
      public function LevelRewardFrame()
      {
         super();
         this.initView();
         info = new AlertInfo();
         info.frameCenter = true;
         info.bottomGap = 16;
      }
      
      private function initView() : void
      {
         var self:SelfInfo = null;
         var p:Point = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.core.levelRewardBg");
         addToContent(this._bg);
         self = PlayerManager.Instance.Self;
         p = ComponentFactory.Instance.creatCustomObject("core.levelReward.posPlayer");
         this._playerView = CharactoryFactory.createCharacter(self,CharactoryFactory.SHOW,true) as ShowCharacter;
         this._playerView.doAction(ShowCharacter.WIN);
         this._playerView.show(true,1,true);
         this._playerView.x = p.x;
         this._playerView.y = p.y;
         if(!self.getSuitesHide() && self.getSuitsType() == 1)
         {
            this._playerView.scaleX = this._playerView.scaleY = 1.3;
         }
         else
         {
            this._playerView.scaleX = this._playerView.scaleY = 1.4;
         }
         addToContent(this._playerView);
         this._up = ComponentFactory.Instance.creatComponentByStylename("asset.core.levelRewardUp3");
         addToContent(this._up);
      }
      
      private function showLv(lv:int) : void
      {
         var posY:int = 0;
         var bmp:Bitmap = null;
         var arr:Array = lv.toString().split("");
         var posX:int = this._up.x + (arr.length > 1 ? 252 : 266);
         posY = this._up.y - 49;
         for(var i:int = 0; i < arr.length; i++)
         {
            bmp = ComponentFactory.Instance.creatBitmap("asset.core.levelRewardRed_" + arr[i]);
            bmp.x = posX + i * 25 + 55;
            bmp.y = posY;
            addToContent(bmp);
         }
      }
      
      public function show($level:int) : void
      {
         if($level > 15)
         {
            return;
         }
         this.level = $level;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function hide() : void
      {
         this.dispose();
         if(WeakGuildManager.Instance.newTask)
         {
            TaskManager.instance.showGetNewQuest();
            WeakGuildManager.Instance.newTask = false;
         }
      }
      
      public function set level(value:int) : void
      {
         if(value > 15)
         {
            return;
         }
         if(value == 2)
         {
            TrainStep.send(TrainStep.Step.LEVEL_TWO);
         }
         else if(value == 3)
         {
            TrainStep.send(TrainStep.Step.SUBMIT_TASK);
         }
         else if(value == 4)
         {
            TrainStep.send(TrainStep.Step.GET_GIFT);
         }
         else if(value == 5)
         {
            TrainStep.send(TrainStep.Step.HARMTWO_TASK_COMPLETE);
         }
         else if(value == 10)
         {
            TrainStep.send(TrainStep.Step.LEVEL_TEN);
         }
         else if(value == 15)
         {
            TrainStep.send(TrainStep.Step.LEVEL_FIFTEEN);
         }
         this._item1 = ComponentFactory.Instance.creatCustomObject("core.levelRewardItem1");
         this._item1.setStyle(value);
         addToContent(this._item1);
         this.showLv(value);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._playerView = null;
         this._up = null;
         if(Boolean(this._item1))
         {
            this._item1.dispose();
            this._item1 = null;
         }
         super.dispose();
      }
   }
}

