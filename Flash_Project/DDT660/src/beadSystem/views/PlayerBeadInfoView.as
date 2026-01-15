package beadSystem.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import road7th.data.DictionaryData;
   import store.view.embed.EmbedStoneCell;
   
   public class PlayerBeadInfoView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _beadCells:DictionaryData;
      
      private var _HoleOpen:DictionaryData;
      
      private var _pointArray:Vector.<Point>;
      
      private var _playerInfo:PlayerInfo;
      
      public function PlayerBeadInfoView()
      {
         super();
         this._HoleOpen = new DictionaryData();
         this._beadCells = new DictionaryData();
         this.getCellsPoint();
         this.initView();
      }
      
      private function initView() : void
      {
         var stoneAttackCell:EmbedStoneCell = null;
         var stoneDefanceCell1:EmbedStoneCell = null;
         var stoneDefanceCell2:EmbedStoneCell = null;
         var i:int = 0;
         var stoneNeedOpen1:EmbedStoneCell = null;
         var stoneNeedOpen2:EmbedStoneCell = null;
         var stoneNeedOpen3:EmbedStoneCell = null;
         var stoneNeedOpen4:EmbedStoneCell = null;
         var stoneNeedOpen6:EmbedStoneCell = null;
         var stoneCell:EmbedStoneCell = null;
         this._bg = ComponentFactory.Instance.creatBitmap("beadSystem.playerBeadInfo.bg");
         addChild(this._bg);
         stoneAttackCell = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[1,1]);
         stoneAttackCell.x = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint1")).x;
         stoneAttackCell.y = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint1")).y;
         stoneAttackCell.StoneType = 1;
         addChild(stoneAttackCell);
         this._beadCells.add(1,stoneAttackCell);
         stoneDefanceCell1 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[2,2]);
         stoneDefanceCell1.x = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint2")).x;
         stoneDefanceCell1.y = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint2")).y;
         stoneDefanceCell1.StoneType = 2;
         addChild(stoneDefanceCell1);
         this._beadCells.add(2,stoneDefanceCell1);
         stoneDefanceCell2 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[3,2]);
         stoneDefanceCell2.x = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint3")).x;
         stoneDefanceCell2.y = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint3")).y;
         stoneDefanceCell2.StoneType = 2;
         addChild(stoneDefanceCell2);
         this._beadCells.add(3,stoneDefanceCell2);
         for(i = 4; i <= 12; i++)
         {
            stoneCell = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[i,3]);
            stoneCell.StoneType = 3;
            stoneCell.x = this._pointArray[i - 1].x;
            stoneCell.y = this._pointArray[i - 1].y;
            addChild(stoneCell);
            this._beadCells.add(i,stoneCell);
         }
         stoneNeedOpen1 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[13,3]);
         stoneNeedOpen1.x = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint13")).x;
         stoneNeedOpen1.y = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint13")).y;
         stoneNeedOpen1.StoneType = 3;
         addChild(stoneNeedOpen1);
         this._beadCells.add(13,stoneNeedOpen1);
         this._HoleOpen.add(13,stoneNeedOpen1);
         stoneNeedOpen2 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[14,3]);
         stoneNeedOpen2.x = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint14")).x;
         stoneNeedOpen2.y = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint14")).y;
         stoneNeedOpen2.StoneType = 3;
         addChild(stoneNeedOpen2);
         this._beadCells.add(14,stoneNeedOpen2);
         this._HoleOpen.add(14,stoneNeedOpen2);
         stoneNeedOpen3 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[15,3]);
         stoneNeedOpen3.x = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint15")).x;
         stoneNeedOpen3.y = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint15")).y;
         stoneNeedOpen3.StoneType = 3;
         addChild(stoneNeedOpen3);
         this._beadCells.add(15,stoneNeedOpen3);
         this._HoleOpen.add(15,stoneNeedOpen3);
         stoneNeedOpen4 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[16,3]);
         stoneNeedOpen4.x = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint16")).x;
         stoneNeedOpen4.y = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint16")).y;
         stoneNeedOpen4.StoneType = 3;
         addChild(stoneNeedOpen4);
         this._beadCells.add(16,stoneNeedOpen4);
         this._HoleOpen.add(16,stoneNeedOpen4);
         var stoneNeedOpen5:EmbedStoneCell = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[17,3]);
         stoneNeedOpen5.x = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint17")).x;
         stoneNeedOpen5.y = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint17")).y;
         stoneNeedOpen5.StoneType = 3;
         addChild(stoneNeedOpen5);
         this._beadCells.add(17,stoneNeedOpen5);
         this._HoleOpen.add(17,stoneNeedOpen5);
         stoneNeedOpen6 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[18,3]);
         stoneNeedOpen6.x = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint18")).x;
         stoneNeedOpen6.y = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint18")).y;
         stoneNeedOpen6.StoneType = 3;
         addChild(stoneNeedOpen6);
         this._beadCells.add(18,stoneNeedOpen6);
         this._HoleOpen.add(18,stoneNeedOpen6);
      }
      
      private function getCellsPoint() : void
      {
         var point:Point = null;
         this._pointArray = new Vector.<Point>();
         for(var i:int = 1; i <= 18; i++)
         {
            point = ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint" + i);
            this._pointArray.push(point);
         }
      }
      
      public function set playerInfo(value:PlayerInfo) : void
      {
         var o:EmbedStoneCell = null;
         var e:EmbedStoneCell = null;
         this._playerInfo = value;
         if(Boolean(value))
         {
            for each(o in this._beadCells)
            {
               o.info = null;
            }
            for each(e in this._beadCells)
            {
               e.otherPlayer = value;
               e.itemInfo = value.BeadBag.getItemAt(e.ID);
               e.info = value.BeadBag.getItemAt(e.ID);
               if(e.ID >= 13 && Boolean(value.BeadBag.getItemAt(e.ID)))
               {
                  e.open();
               }
            }
         }
      }
      
      public function dispose() : void
      {
         var o:* = undefined;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         for each(o in this._beadCells)
         {
            ObjectUtils.disposeObject(o);
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

