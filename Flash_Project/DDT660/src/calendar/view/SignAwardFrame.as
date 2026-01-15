package calendar.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DaylyGiveInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class SignAwardFrame extends BaseAlerFrame
   {
      
      private var _back:DisplayObject;
      
      private var _awardCells:Vector.<SignAwardCell> = new Vector.<SignAwardCell>();
      
      private var _awards:Array;
      
      private var _signCount:int;
      
      public function SignAwardFrame()
      {
         super();
         this.configUI();
      }
      
      private function __response(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         ObjectUtils.disposeObject(this);
      }
      
      public function show(signCount:int, awards:Array) : void
      {
         var topleft:Point = null;
         var count:int = 0;
         var item:DaylyGiveInfo = null;
         var cell:SignAwardCell = null;
         this._signCount = signCount;
         this._awards = awards;
         topleft = ComponentFactory.Instance.creatCustomObject("Calendar.SignAward.TopLeft");
         var row:int = 0;
         count = 0;
         for each(item in this._awards)
         {
            cell = ComponentFactory.Instance.creatCustomObject("SignAwardCell");
            this._awardCells.push(cell);
            cell.info = ItemManager.Instance.getTemplateById(item.TemplateID);
            cell.setCount(item.Count);
            if(count % 2 == 0)
            {
               cell.x = topleft.x;
               cell.y = topleft.y + row * 64;
            }
            else
            {
               cell.x = topleft.x + 139;
               cell.y = topleft.y + row * 64;
               row++;
            }
            addToContent(cell);
            count++;
         }
         addEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function configUI() : void
      {
         info = new AlertInfo(LanguageMgr.GetTranslation("tank.calendar.sign.title"),LanguageMgr.GetTranslation("ok"),"",true,false);
         this._back = ComponentFactory.Instance.creatComponentByStylename("Calendar.SignAward.Back");
         addToContent(this._back);
      }
      
      override public function dispose() : void
      {
         while(this._awardCells.length > 0)
         {
            ObjectUtils.disposeObject(this._awardCells.shift());
         }
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         super.dispose();
      }
   }
}

