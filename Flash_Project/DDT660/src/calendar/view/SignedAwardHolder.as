package calendar.view
{
   import calendar.CalendarModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DaylyGiveInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class SignedAwardHolder extends Sprite implements Disposeable
   {
      
      private var _back:DisplayObject;
      
      private var _model:CalendarModel;
      
      private var _awardCells:Vector.<SignAwardCell> = new Vector.<SignAwardCell>();
      
      private var _beeReward:DisplayObject;
      
      private var _bigBack:MutipleImage;
      
      private var _nameField:FilterFrameText;
      
      public function SignedAwardHolder(model:CalendarModel)
      {
         super();
         this._model = model;
         this.configUI();
      }
      
      public function setAwardsByCount(signCount:int) : void
      {
         var award:DaylyGiveInfo = null;
         var cell:SignAwardCell = null;
         this.clean();
         var topleft:Point = ComponentFactory.Instance.creatCustomObject("ddtcalendar.Award.cell.TopLeft");
         var count:int = 0;
         for each(award in this._model.awards)
         {
            if(award.AwardDays == signCount)
            {
               cell = ComponentFactory.Instance.creatCustomObject("ddtcalendar.SignAwardCell");
               this._awardCells.push(cell);
               if(award.TemplateID == 1)
               {
                  cell.info = ItemManager.Instance.getTemplateById(ServerConfigManager.instance.dailyRewardIDForMonth[TimeManager.Instance.Now().getMonth()]);
               }
               else
               {
                  cell.info = ItemManager.Instance.getTemplateById(award.TemplateID);
               }
               cell.x = topleft.x + count * 132;
               cell.y = topleft.y;
               cell.setCount(award.Count);
               addChild(cell);
               count++;
            }
         }
         if(signCount == 28)
         {
            this._bigBack = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.SignedAward.SignAwardCellBg2");
            addChild(this._bigBack);
            PositionUtils.setPos(this._bigBack,"ddtcalendar.SignedAward.SignAwardCellBgPos");
            this._nameField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.AwardNameField");
            addChild(this._nameField);
            this._nameField.text = "Küçük Arı";
            PositionUtils.setPos(this._nameField,"ddtcalendar.AwardNameFieldPos");
            this._beeReward = ComponentFactory.Instance.creat("ddtcalendar.bee");
            addChild(this._beeReward);
            PositionUtils.setPos(this._beeReward,"ddtcalendar.beePos");
            this._bigBack.tipData = "Ödül Açıklaması:\nSaldırı +5 Defans +5";
         }
      }
      
      public function clean() : void
      {
         var cell:SignAwardCell = null;
         for(var i:int = 0; i < this._awardCells.length; i++)
         {
            cell = this._awardCells[i] as SignAwardCell;
            ObjectUtils.disposeObject(cell);
            cell = null;
         }
         this._awardCells.splice(0,this._awardCells.length);
         if(Boolean(this._beeReward))
         {
            ObjectUtils.disposeObject(this._beeReward);
            this._beeReward = null;
         }
         if(Boolean(this._bigBack))
         {
            ObjectUtils.disposeObject(this._bigBack);
            this._bigBack = null;
         }
         if(Boolean(this._nameField))
         {
            ObjectUtils.disposeObject(this._nameField);
            this._nameField = null;
         }
      }
      
      private function configUI() : void
      {
      }
      
      public function dispose() : void
      {
         this.clean();
         this._model = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

