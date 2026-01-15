package newYearRice
{
   import cloudBuyLottery.loader.LoaderUIModule;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import newYearRice.data.NewYearRicePackageType;
   import newYearRice.model.NewYearRiceModel;
   import newYearRice.view.NewYearRiceMainView;
   import newYearRice.view.NewYearRiceOpenFrameView;
   import road7th.comm.PackageIn;
   
   public class NewYearRiceManager extends EventDispatcher
   {
      
      private static var _instance:NewYearRiceManager;
      
      public static const UPDATEVIEW:String = "updateView";
      
      private var _model:NewYearRiceModel;
      
      private var _main:NewYearRiceMainView;
      
      private var _openFrameView:NewYearRiceOpenFrameView;
      
      public function NewYearRiceManager(pct:PrivateClass)
      {
         super();
      }
      
      public static function get instance() : NewYearRiceManager
      {
         if(NewYearRiceManager._instance == null)
         {
            NewYearRiceManager._instance = new NewYearRiceManager(new PrivateClass());
         }
         return NewYearRiceManager._instance;
      }
      
      public function setup() : void
      {
         this._model = new NewYearRiceModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NEW_YEAR_RICE,this.pkgHandler);
      }
      
      private function pkgHandler(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         var cmd:int = e._cmd;
         var event:CrazyTankSocketEvent = null;
         switch(cmd)
         {
            case NewYearRicePackageType.NEWYEARRICE_OPENORCLOSE:
               this.openOrclose(pkg);
               break;
            case NewYearRicePackageType.NEWYEARRICE_INFO:
               this.openNewYearRiceView(pkg);
               break;
            case NewYearRicePackageType.YEARFOODCOOK:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.YEARFOODCOOK,pkg);
               break;
            case NewYearRicePackageType.YEARFOODENTER:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.YEARFOODENTER,pkg);
               break;
            case NewYearRicePackageType.YEARFOODINVITE:
               this.yearFoodRoomInvitePlayer(pkg);
               break;
            case NewYearRicePackageType.YEARFOODEXITROOM:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.EXITYEARFOODROOM,pkg);
               break;
            case NewYearRicePackageType.YEARFOODROOMINVITE:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.YEARFOODROOMINVITE,pkg);
               break;
            case NewYearRicePackageType.YEARFOODCREATEFOOD:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.YEARFOODCREATEFOOD,pkg);
         }
         if(Boolean(event))
         {
            dispatchEvent(event);
         }
      }
      
      private function openOrclose(pkg:PackageIn = null) : void
      {
         this._model.isOpen = pkg.readBoolean();
         this.showEnterIcon(this._model.isOpen);
      }
      
      private function yearFoodRoomInvitePlayer(pkg:PackageIn) : void
      {
         var i:int = 0;
         var obj:Object = null;
         this._model.roomType = pkg.readInt();
         this._model.playersLength = pkg.readInt();
         if(this._model.playersLength > 0)
         {
            this._model.playersArray = [];
            for(i = 0; i < this._model.playersLength; i++)
            {
               obj = new Object();
               obj.ID = pkg.readInt();
               obj.Style = pkg.readUTF();
               obj.NikeName = pkg.readUTF();
               obj.Sex = pkg.readBoolean();
               this._model.playersArray[i] = obj;
            }
            if(NewYearRiceManager.instance.model.openFrameView != null)
            {
               dispatchEvent(new Event(UPDATEVIEW));
            }
            else
            {
               StateManager.setState(StateType.MAIN);
               LoaderUIModule.Instance.loadUIModule(this.addOpenFrameView,null,UIModuleTypes.NEWYEARRICE);
            }
         }
      }
      
      private function addOpenFrameView() : void
      {
         if(Boolean(this._openFrameView))
         {
            ObjectUtils.disposeObject(this._openFrameView);
            this._openFrameView = null;
         }
         this._openFrameView = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.NewYearRiceOpenView");
         this._openFrameView.setViewFrame(this._model.roomType);
         this._openFrameView.updatePlayerItem(this._model.playersArray);
         this._openFrameView.setBtnEnter();
         LayerManager.Instance.addToLayer(this._openFrameView,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function openNewYearRiceView(pkg:PackageIn) : void
      {
         this._model.yearFoodInfo = pkg.readInt();
         LoaderUIModule.Instance.loadUIModule(this.initOpenFrame,null,UIModuleTypes.NEWYEARRICE);
      }
      
      public function onClickNewYearRiceIcon(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(StateManager.currentStateType == StateType.MAIN)
         {
            SocketManager.Instance.out.sendCheckNewYearRiceInfo();
         }
      }
      
      private function initOpenFrame() : void
      {
         this._main = ComponentFactory.Instance.creatComponentByStylename("NewYearRice.MainView");
         LayerManager.Instance.addToLayer(this._main,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function showEnterIcon(flag:Boolean) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.NEWYEARRICE,flag);
         if(this._main != null && flag == false)
         {
            if(Boolean(this._main))
            {
               ObjectUtils.disposeObject(this._main);
            }
            this._main = null;
         }
      }
      
      public function returnComponent(cell:Bitmap, tipName:String) : Component
      {
         var compoent:Component = new Component();
         compoent.tipData = tipName;
         compoent.tipDirctions = "0,1,2";
         compoent.tipStyle = "ddt.view.tips.OneLineTip";
         compoent.tipGapH = 20;
         compoent.width = cell.width;
         compoent.x = cell.x;
         compoent.y = cell.y;
         cell.x = 0;
         cell.y = 0;
         compoent.addChild(cell);
         return compoent;
      }
      
      public function get model() : NewYearRiceModel
      {
         return this._model;
      }
      
      public function templateDataSetup(dataList:Array) : void
      {
         this._model.itemInfoList = dataList;
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
