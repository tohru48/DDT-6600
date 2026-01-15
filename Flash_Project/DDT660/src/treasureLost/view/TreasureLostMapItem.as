package treasureLost.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class TreasureLostMapItem extends Sprite implements Disposeable
   {
      
      public var id:int;
      
      public var posStr:String;
      
      public var type:int;
      
      private var iconSp:Sprite;
      
      public function TreasureLostMapItem($id:int, $type:int, $pos:String)
      {
         super();
         this.id = $id;
         this.type = $type;
         this.posStr = $pos;
         this.initView();
      }
      
      private function initView() : void
      {
         this.iconSp = this.creatIcon(this.type);
         addChild(this.iconSp);
         this.setPos(this.posStr);
      }
      
      public function setPos($posStr:String) : void
      {
         var posArr:Array = $posStr.split(",");
         this.x = int(posArr[0]);
         this.y = int(posArr[1]);
         if(this.id == 0)
         {
            this.scaleX = 1.2;
            this.scaleY = 1.2;
         }
      }
      
      public function changeState($type:int) : void
      {
         if(Boolean(this.iconSp))
         {
            removeChild(this.iconSp);
         }
         this.iconSp = this.creatIcon($type);
         addChild(this.iconSp);
         this.type = $type;
         this.setPos(this.posStr);
      }
      
      private function creatIcon(id:int) : Sprite
      {
         var sp:Sprite = null;
         var bitMap:Bitmap = null;
         var cmp1:Component = null;
         var info:ItemTemplateInfo = null;
         var cell:BagCell = null;
         var cellBg:Bitmap = null;
         sp = new Sprite();
         switch(id)
         {
            case 0:
               bitMap = ComponentFactory.Instance.creat("treasureLost.map.nothing");
               break;
            case -1:
               bitMap = ComponentFactory.Instance.creat("treasureLost.map.return0");
               break;
            case -2:
               bitMap = ComponentFactory.Instance.creat("treasureLost.map.gotoEnd");
               break;
            case -3:
               bitMap = ComponentFactory.Instance.creat("treasureLost.map.doubleAward");
               cmp1 = ComponentFactory.Instance.creat("treasureLost.cellTipComponent");
               cmp1.tipData = LanguageMgr.GetTranslation("treasureLost.tipText.doubleReward");
               sp = cmp1;
               break;
            case -4:
               bitMap = ComponentFactory.Instance.creat("treasureLost.map.prefectRoll");
               break;
            case -5:
               bitMap = ComponentFactory.Instance.creat("treasureLost.map.npcFight");
               break;
            case -10:
               bitMap = ComponentFactory.Instance.creat("treasureLost.map.goed");
               break;
            case -11:
               bitMap = ComponentFactory.Instance.creat("treasureLost.map.changeDirection");
               break;
            case -13:
               bitMap = ComponentFactory.Instance.creat("treasureLost.map.enterPoint");
               break;
            case -6:
               bitMap = ComponentFactory.Instance.creat("treasureLost.map.random");
               break;
            default:
               info = ItemManager.Instance.getTemplateById(id);
               cell = new BagCell(0,info);
               cell.setBgVisible(false);
               cell.width = 55;
               cell.height = 50;
               cell.x = 4;
               cell.y = 2;
               cellBg = ComponentFactory.Instance.creatBitmap("treasureLost.map.nothing");
               cellBg.smoothing = true;
               cellBg.width = 55;
               cellBg.height = 50;
               sp.addChild(cellBg);
               sp.addChild(cell);
         }
         if(Boolean(bitMap))
         {
            bitMap.smoothing = true;
            bitMap.width = 55;
            bitMap.height = 50;
            sp.addChild(bitMap);
         }
         sp.x = 3;
         sp.y = 1;
         return sp;
      }
      
      public function dispose() : void
      {
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}

