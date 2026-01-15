package wonderfulActivity.limitActivity
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.utils.Dictionary;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import mysteriousRoullete.MysteriousManager;
   import treasureHunting.TreasureManager;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.ActivityCellVo;
   import wonderfulActivity.views.WonderfulRightView;
   
   public class LimitActivityFrame extends Frame
   {
      
      private var _bag:ScaleBitmapImage;
      
      private var _leftView:LimitActivityLeftView;
      
      private var _rightView:WonderfulRightView;
      
      private var allMusic:Boolean;
      
      public function LimitActivityFrame()
      {
         super();
         escEnable = true;
         this.allMusic = SharedManager.Instance.allowMusic;
         SharedManager.Instance.allowMusic = false;
         SharedManager.Instance.changed();
         this.initview();
         this.addEvents();
      }
      
      public function setState(type:int, id:int) : void
      {
         if(!this._rightView && !this._rightView.parent)
         {
            return;
         }
         this._rightView.setState(type,id);
      }
      
      private function initview() : void
      {
         titleText = LanguageMgr.GetTranslation("ddt.limitActivityFrame.tittle");
         this._bag = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.scale9cornerImageTree");
         this._bag.width = 765;
         addToContent(this._bag);
         this._leftView = new LimitActivityLeftView();
         this._leftView.x = 20;
         this._leftView.y = 47;
         addToContent(this._leftView);
         this._rightView = new WonderfulRightView();
         PositionUtils.setPos(this._rightView,"limitActivity.wonderfulRightViewPos");
         addToContent(this._rightView);
         this._leftView.setRightView(this._rightView.updateView);
      }
      
      private function addEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      public function addElement(actArr:Array) : void
      {
         var vo:ActivityCellVo = null;
         var id:String = null;
         var limitArr:Array = [];
         var infoDic:Dictionary = WonderfulActivityManager.Instance.leftViewInfoDic;
         for each(id in actArr)
         {
            vo = new ActivityCellVo();
            vo.id = id;
            vo.activityName = infoDic[id].label;
            vo.viewType = infoDic[id].viewType;
            limitArr.push(vo);
         }
         this._leftView.setData(limitArr);
      }
      
      private function _response(evt:FrameEvent) : void
      {
         if(!WonderfulActivityManager.Instance.isRuning)
         {
            return;
         }
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            if(WonderfulActivityManager.Instance.frameCanClose)
            {
               SoundManager.instance.play("008");
               this.clear();
            }
         }
      }
      
      private function clear() : void
      {
         TreasureManager.instance.dispose();
         if(MysteriousManager.instance.isMysteriousClose)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.MYSTERIOUROULETTE,false);
         }
         this.dispose();
         WonderfulActivityManager.Instance.dispose();
      }
      
      override public function dispose() : void
      {
         if(!WonderfulActivityManager.Instance.isRuning)
         {
            return;
         }
         SharedManager.Instance.allowMusic = this.allMusic;
         SharedManager.Instance.changed();
         this.removeEvents();
         ObjectUtils.disposeObject(this._leftView);
         ObjectUtils.disposeObject(this._rightView);
         this._leftView = null;
         this._rightView = null;
         super.dispose();
      }
   }
}

