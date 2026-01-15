package trainer.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import trainer.controller.LevelRewardManager;
   import trainer.data.LevelRewardInfo;
   
   public class LevelRewardItem extends Sprite
   {
      
      private var _level:int;
      
      private var _bg:Bitmap;
      
      private var _txt:Bitmap;
      
      private var _item2:LevelRewardInfo;
      
      private var _item3:LevelRewardInfo;
      
      private var _levelRewardListII:LevelRewardList;
      
      private var _levelRewardListIII:LevelRewardList;
      
      public function LevelRewardItem()
      {
         super();
      }
      
      public function setStyle(level:int) : void
      {
         this._level = level;
         this.initView();
      }
      
      private function initView() : void
      {
         this._item2 = LevelRewardManager.Instance.getRewardInfo(this._level,2);
         this._item3 = LevelRewardManager.Instance.getRewardInfo(this._level,3);
         this._bg = ComponentFactory.Instance.creatBitmap("asset.core.levelRewardBg2");
         addChild(this._bg);
         this.currentLevel();
         this._txt = ComponentFactory.Instance.creatBitmap("asset.core.levelRewardTxt");
         addChild(this._txt);
      }
      
      private function currentLevel() : void
      {
         var k:int = 0;
         var it0:ItemTemplateInfo = null;
         var cell0:BaseCell = null;
         var j:int = 0;
         var it1:ItemTemplateInfo = null;
         var cell1:BaseCell = null;
         if(this._item2 != null)
         {
            if(this._item2.items.length > 0)
            {
               this._levelRewardListII = ComponentFactory.Instance.creatCustomObject("trainer.currentLevel.levelRewardListII");
               for(k = 0; k < this._item2.items.length; k++)
               {
                  it0 = ItemManager.Instance.getTemplateById(int(this._item2.items[k]));
                  cell0 = new LevelRewardCell(it0);
                  this._levelRewardListII.addCell(cell0);
               }
               addChild(this._levelRewardListII);
            }
         }
         if(this._item3 != null)
         {
            if(this._item3.items.length > 0)
            {
               this._levelRewardListIII = ComponentFactory.Instance.creatCustomObject("trainer.currentLevel.levelRewardListIII");
               for(j = 0; j < this._item3.items.length; j++)
               {
                  it1 = ItemManager.Instance.getTemplateById(int(this._item3.items[j]));
                  cell1 = new LevelRewardCell(it1);
                  this._levelRewardListIII.addCell(cell1);
               }
               addChild(this._levelRewardListIII);
            }
         }
         this.addListEvent();
      }
      
      private function addListEvent() : void
      {
         if(Boolean(this._levelRewardListII))
         {
            this._levelRewardListII.addEventListener(MouseEvent.MOUSE_OVER,this.__onListOver);
         }
         if(Boolean(this._levelRewardListIII))
         {
            this._levelRewardListIII.addEventListener(MouseEvent.MOUSE_OVER,this.__onListOver);
         }
      }
      
      private function removeListEvent() : void
      {
         if(Boolean(this._levelRewardListII))
         {
            this._levelRewardListII.removeEventListener(MouseEvent.MOUSE_OVER,this.__onListOver);
         }
         if(Boolean(this._levelRewardListIII))
         {
            this._levelRewardListIII.removeEventListener(MouseEvent.MOUSE_OVER,this.__onListOver);
         }
      }
      
      private function __onListOver(event:MouseEvent) : void
      {
         addChild(event.currentTarget as DisplayObject);
      }
      
      public function dispose() : void
      {
         this.removeListEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._bg = null;
         if(Boolean(this._levelRewardListII))
         {
            this._levelRewardListII.disopse();
            this._levelRewardListII = null;
         }
         if(Boolean(this._levelRewardListIII))
         {
            this._levelRewardListIII.disopse();
            this._levelRewardListIII = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

