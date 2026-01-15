package bagAndInfo.cell
{
   import bagAndInfo.bag.BreakGoodsBtn;
   import bagAndInfo.bag.ContinueGoodsBtn;
   import bagAndInfo.bag.SellGoodsBtn;
   import bagAndInfo.bag.SellGoodsFrame;
   import baglocked.BagLockedController;
   import baglocked.BaglockedManager;
   import baglocked.SetPassEvent;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import enchant.EnchantManager;
   import farm.viewx.FarmFieldBlock;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import magicHouse.MagicHouseManager;
   import petsBag.controller.PetBagController;
   import petsBag.view.item.SkillItem;
   import playerDress.components.DressUtils;
   
   public class BagCell extends BaseCell
   {
      
      protected var _place:int;
      
      public var _tbxCount:FilterFrameText;
      
      protected var _bgOverDate:Bitmap;
      
      protected var _cellMouseOverBg:Bitmap;
      
      protected var _cellMouseOverFormer:Bitmap;
      
      private var _mouseOverEffBoolean:Boolean;
      
      protected var _bagType:int;
      
      protected var _isShowIsUsedBitmap:Boolean;
      
      protected var _isUsed:Boolean;
      
      protected var _isUsedBitmap:Bitmap;
      
      protected var _enchantMc:MovieClip;
      
      protected var _enchantMcName:String = "asset.enchant.level";
      
      protected var _enchantMcPosStr:String = "enchant.levelMcPos";
      
      private var placeArr:Array = [0,1,2];
      
      protected var temInfo:InventoryItemInfo;
      
      private var _sellFrame:SellGoodsFrame;
      
      public function BagCell(index:int, info:ItemTemplateInfo = null, showLoading:Boolean = true, bg:DisplayObject = null, mouseOverEffBoolean:Boolean = true)
      {
         this._mouseOverEffBoolean = mouseOverEffBoolean;
         super(Boolean(bg) ? bg : ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellBgAsset"),info,showLoading);
         this._place = index;
      }
      
      public function setBgVisible(bool:Boolean) : void
      {
         _bg.visible = bool;
      }
      
      public function set mouseOverEffBoolean(boolean:Boolean) : void
      {
         this._mouseOverEffBoolean = boolean;
      }
      
      public function get bagType() : int
      {
         return this._bagType;
      }
      
      public function set bagType(value:int) : void
      {
         this._bagType = value;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         locked = false;
         this._bgOverDate = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.overDateBgAsset");
         if(this._mouseOverEffBoolean == true)
         {
            this._cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
            this._cellMouseOverFormer = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverShareBG");
            addChild(this._cellMouseOverBg);
            addChild(this._cellMouseOverFormer);
         }
         addChild(this._bgOverDate);
         this._tbxCount = ComponentFactory.Instance.creatComponentByStylename("BagCellCountText");
         this._tbxCount.mouseEnabled = false;
         addChild(this._tbxCount);
         this.updateCount();
         this.checkOverDate();
         this.updateBgVisible(false);
      }
      
      public function set isUsed(value:Boolean) : void
      {
         this._isUsed = value;
      }
      
      public function get isUsed() : Boolean
      {
         return this._isUsed;
      }
      
      protected function addIsUsedBitmap() : void
      {
         this._isUsedBitmap = ComponentFactory.Instance.creat("asset.store.isUsedBitmap");
         this._isUsedBitmap.x = 22;
         this._isUsedBitmap.y = 1;
         addChild(this._isUsedBitmap);
      }
      
      protected function addEnchantMc() : void
      {
         var mcLevel:int = this.itemInfo.MagicLevel >= EnchantManager.instance.infoVec.length ? int(this.itemInfo.MagicLevel / 10) : int(this.itemInfo.MagicLevel / 10) + 1;
         this._enchantMc = ComponentFactory.Instance.creat(this._enchantMcName + mcLevel);
         PositionUtils.setPos(this._enchantMc,this._enchantMcPosStr);
         addChild(this._enchantMc);
      }
      
      override public function set info(value:ItemTemplateInfo) : void
      {
         super.info = value;
         if(value && this._isShowIsUsedBitmap && this.isUsed)
         {
            this.addIsUsedBitmap();
         }
         else if(!value)
         {
            if(Boolean(this._isUsedBitmap))
            {
               ObjectUtils.disposeObject(this._isUsedBitmap);
            }
            this._isUsedBitmap = null;
         }
         if(Boolean(this._enchantMc))
         {
            this._enchantMc.stop();
            this._enchantMc.parent.removeChild(this._enchantMc);
            this._enchantMc = null;
         }
         if(this.itemInfo && this.itemInfo.isCanEnchant() && this.itemInfo.MagicLevel > 0)
         {
            this.addEnchantMc();
         }
         this.updateCount();
         this.checkOverDate();
      }
      
      override protected function onMouseClick(evt:MouseEvent) : void
      {
      }
      
      override protected function onMouseOver(evt:MouseEvent) : void
      {
      }
      
      override protected function onMouseOut(evt:MouseEvent) : void
      {
         super.onMouseOut(evt);
         this.updateBgVisible(false);
      }
      
      public function onParentMouseOver(cellMouseOverBgEff:Bitmap) : void
      {
         if(!this._cellMouseOverBg)
         {
            this._cellMouseOverBg = cellMouseOverBgEff;
            addChild(this._cellMouseOverBg);
            super.setChildIndex(this._cellMouseOverBg,1);
            this.updateBgVisible(true);
         }
      }
      
      public function onParentMouseOut() : void
      {
         if(Boolean(this._cellMouseOverBg))
         {
            this.updateBgVisible(false);
            this._cellMouseOverBg = null;
         }
      }
      
      protected function updateBgVisible(visible:Boolean) : void
      {
         if(Boolean(this._cellMouseOverBg))
         {
            this._cellMouseOverBg.visible = visible;
            this._cellMouseOverFormer.visible = visible;
            setChildIndex(this._cellMouseOverFormer,numChildren - 1);
         }
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
         var info:InventoryItemInfo = null;
         var alert:BaseAlerFrame = null;
         if(effect.source is SkillItem)
         {
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            effect.action = DragEffect.NONE;
            super.dragStop(effect);
            return;
         }
         if(effect.data is InventoryItemInfo)
         {
            info = effect.data as InventoryItemInfo;
            if(locked)
            {
               if(info == this.info)
               {
                  this.locked = false;
                  DragManager.acceptDrag(this);
               }
               else
               {
                  DragManager.acceptDrag(this,DragEffect.NONE);
               }
            }
            else
            {
               if(this._bagType == BagInfo.CONSORTIA || info.BagType == BagInfo.CONSORTIA)
               {
                  if(effect.action == DragEffect.SPLIT)
                  {
                     effect.action = DragEffect.NONE;
                  }
                  else if(this._bagType != BagInfo.CONSORTIA)
                  {
                     if(DressUtils.isDress(info))
                     {
                        SocketManager.Instance.out.sendMoveGoods(BagInfo.CONSORTIA,info.Place,BagInfo.EQUIPBAG,-1,1);
                     }
                     else
                     {
                        SocketManager.Instance.out.sendMoveGoods(BagInfo.CONSORTIA,info.Place,this._bagType,this.place,info.Count);
                     }
                     effect.action = DragEffect.NONE;
                  }
                  else if(this._bagType == info.BagType)
                  {
                     if(this.place >= PlayerManager.Instance.Self.consortiaInfo.StoreLevel * 10)
                     {
                        effect.action = DragEffect.NONE;
                     }
                     else
                     {
                        SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,info.BagType,this.place,info.Count);
                     }
                  }
                  else if(PlayerManager.Instance.Self.consortiaInfo.StoreLevel < 1)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.cellDoubleClick"));
                     effect.action = DragEffect.NONE;
                  }
                  else
                  {
                     SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,this._bagType,this.place,info.Count);
                     effect.action = DragEffect.NONE;
                  }
               }
               else if(this._bagType == BagInfo.MAGICHOUSE || info.BagType == BagInfo.MAGICHOUSE)
               {
                  if(effect.action == DragEffect.SPLIT)
                  {
                     effect.action = DragEffect.NONE;
                  }
                  else if(this._bagType != BagInfo.MAGICHOUSE)
                  {
                     if(DressUtils.isDress(info))
                     {
                        SocketManager.Instance.out.sendMoveGoods(BagInfo.MAGICHOUSE,info.Place,BagInfo.EQUIPBAG,-1,1);
                     }
                     else
                     {
                        SocketManager.Instance.out.sendMoveGoods(BagInfo.MAGICHOUSE,info.Place,this._bagType,this.place,info.Count);
                     }
                     effect.action = DragEffect.NONE;
                  }
                  else if(this._bagType == info.BagType)
                  {
                     if(this.place >= MagicHouseManager.instance.depotCount)
                     {
                        effect.action = DragEffect.NONE;
                     }
                     else
                     {
                        SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,info.BagType,this.place,info.Count);
                     }
                  }
                  else
                  {
                     SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,this._bagType,this.place,info.Count);
                     effect.action = DragEffect.NONE;
                  }
               }
               else if(info.BagType == this._bagType)
               {
                  if(!this.itemInfo)
                  {
                     if(info.isMoveSpace)
                     {
                        if(!PetBagController.instance().petModel.currentPetInfo)
                        {
                           SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,info.BagType,this.place,info.Count);
                           effect.action = DragEffect.NONE;
                           return;
                        }
                        if(info.CategoryID == 50 && int(info.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level && info.Place == 0)
                        {
                           SocketManager.Instance.out.delPetEquip(PetBagController.instance().petModel.currentPetInfo.Place,0);
                           PetBagController.instance().isEquip = false;
                        }
                        else if(info.CategoryID == 51 && int(info.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level && info.Place == 1)
                        {
                           SocketManager.Instance.out.delPetEquip(PetBagController.instance().petModel.currentPetInfo.Place,1);
                           PetBagController.instance().isEquip = false;
                        }
                        else if(info.CategoryID == 52 && int(info.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level && info.Place == 2)
                        {
                           SocketManager.Instance.out.delPetEquip(PetBagController.instance().petModel.currentPetInfo.Place,2);
                           PetBagController.instance().isEquip = false;
                        }
                        else
                        {
                           SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,info.BagType,this.place,info.Count);
                        }
                     }
                     effect.action = DragEffect.NONE;
                     return;
                  }
                  if(info.CategoryID == this.itemInfo.CategoryID && info.Place <= 30 && (info.BindType == 1 || info.BindType == 2 || info.BindType == 3) && this.itemInfo.IsBinds == false && EquipType.canEquip(info))
                  {
                     alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
                     alert.addEventListener(FrameEvent.RESPONSE,this.__onCellResponse);
                     this.temInfo = info;
                  }
                  else if(EquipType.isHealStone(info))
                  {
                     if(PlayerManager.Instance.Self.Grade >= int(info.Property1))
                     {
                        SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,info.BagType,this.place,info.Count);
                        effect.action = DragEffect.NONE;
                     }
                     else if(PlayerManager.Instance.Self.Grade < int(info.Property1) && info.Place > 30)
                     {
                        SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,info.BagType,this.place,info.Count);
                        effect.action = DragEffect.NONE;
                     }
                     else if(effect.action == DragEffect.MOVE)
                     {
                        if(effect.source is BagCell)
                        {
                           BagCell(effect.source).locked = false;
                        }
                     }
                     else
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.HealStone.ErrorGrade",info.Property1));
                     }
                  }
                  else
                  {
                     if(!PetBagController.instance().petModel.currentPetInfo)
                     {
                        SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,info.BagType,this.place,info.Count);
                        effect.action = DragEffect.NONE;
                        return;
                     }
                     if(PetBagController.instance().isEquip)
                     {
                        PetBagController.instance().isEquip = false;
                        effect.action = DragEffect.NONE;
                        DragManager.acceptDrag(this);
                        return;
                     }
                     if(info.CategoryID == 50 && int(info.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level && info.Place == 0)
                     {
                        SocketManager.Instance.out.delPetEquip(PetBagController.instance().petModel.currentPetInfo.Place,0);
                     }
                     else if(info.CategoryID == 51 && int(info.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level && info.Place == 1)
                     {
                        SocketManager.Instance.out.delPetEquip(PetBagController.instance().petModel.currentPetInfo.Place,1);
                     }
                     else if(info.CategoryID == 52 && int(info.Property2) <= PetBagController.instance().petModel.currentPetInfo.Level && info.Place == 2)
                     {
                        SocketManager.Instance.out.delPetEquip(PetBagController.instance().petModel.currentPetInfo.Place,2);
                     }
                     else
                     {
                        SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,info.BagType,this.place,info.Count);
                     }
                     if(!this.isPetBagCellMove(effect.source as BagCell,this))
                     {
                        effect.action = DragEffect.NONE;
                     }
                  }
               }
               else if(info.BagType == BagInfo.STOREBAG)
               {
                  if(info.CategoryID == EquipType.TEXP || info.CategoryID == EquipType.FOOD)
                  {
                     SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,this._bagType,this.place,info.Count);
                  }
                  effect.action = DragEffect.NONE;
               }
               else
               {
                  effect.action = DragEffect.NONE;
               }
               DragManager.acceptDrag(this);
            }
         }
         else if(effect.data is SellGoodsBtn)
         {
            if(!locked && _info && this._bagType != BagInfo.CONSORTIA && this._bagType != BagInfo.MAGICHOUSE)
            {
               locked = true;
               DragManager.acceptDrag(this);
            }
         }
         else if(effect.data is ContinueGoodsBtn)
         {
            if(!locked && _info && this._bagType != BagInfo.CONSORTIA && this._bagType != BagInfo.MAGICHOUSE)
            {
               locked = true;
               DragManager.acceptDrag(this,DragEffect.NONE);
            }
         }
         else if(effect.data is BreakGoodsBtn)
         {
            if(!locked && Boolean(_info))
            {
               DragManager.acceptDrag(this);
            }
         }
      }
      
      private function isPetBagCellMove(source:BagCell, target:BagCell) : Boolean
      {
         var targetInfo:InventoryItemInfo = target.info as InventoryItemInfo;
         var sourceInfo:InventoryItemInfo = source.info as InventoryItemInfo;
         if(this.placeArr.indexOf(targetInfo.Place) != -1 && this.placeArr.indexOf(sourceInfo.Place) == -1)
         {
            return false;
         }
         return true;
      }
      
      private function sendDefy() : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.canEquip(this.temInfo))
         {
            SocketManager.Instance.out.sendMoveGoods(this.temInfo.BagType,this.temInfo.Place,this.temInfo.BagType,this.place,this.temInfo.Count);
         }
      }
      
      override public function dragStart() : void
      {
         super.dragStart();
         if(Boolean(_info) && _pic.numChildren > 0)
         {
            dispatchEvent(new CellEvent(CellEvent.DRAGSTART,this.info,true));
         }
      }
      
      override public function dragStop(effect:DragEffect) : void
      {
         var equipPlace:int = 0;
         var targetCell:BagCell = null;
         SoundManager.instance.play("008");
         dispatchEvent(new CellEvent(CellEvent.DRAGSTOP,null,true));
         var $info:InventoryItemInfo = effect.data as InventoryItemInfo;
         if(effect.action == DragEffect.NONE && effect.target != null)
         {
            if($info.CategoryID == 50 || $info.CategoryID == 51 || $info.CategoryID == 52)
            {
               if(effect.target is BagCell)
               {
                  targetCell = effect.target as BagCell;
                  if($info.CategoryID == targetCell.info.CategoryID)
                  {
                     if(this.placeArr.indexOf($info.Place) != -1)
                     {
                        equipPlace = targetCell.itemInfo.Place;
                     }
                     else
                     {
                        equipPlace = $info.Place;
                     }
                     SocketManager.Instance.out.addPetEquip(equipPlace,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
                  }
               }
               else
               {
                  SocketManager.Instance.out.addPetEquip($info.Place,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
               }
            }
         }
         if(effect.action == DragEffect.MOVE && effect.target != null)
         {
            if($info.CategoryID == 50 || $info.CategoryID == 51 || $info.CategoryID == 52)
            {
               effect.action = DragEffect.NONE;
               super.dragStop(effect);
            }
            return;
         }
         if(effect.action == DragEffect.MOVE && effect.target == null)
         {
            if($info.CategoryID == 50 || $info.CategoryID == 51 || $info.CategoryID == 52)
            {
               effect.action = DragEffect.NONE;
               super.dragStop(effect);
            }
            else if(Boolean($info) && $info.BagType == BagInfo.CONSORTIA)
            {
               effect.action = DragEffect.NONE;
               super.dragStop(effect);
            }
            else if(Boolean($info) && $info.BagType == BagInfo.STOREBAG)
            {
               locked = false;
            }
            else if(Boolean($info) && $info.BagType == BagInfo.BEADBAG)
            {
               locked = false;
            }
            else if($info.CategoryID == 34)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.sell.CanNotSell"));
               effect.action = DragEffect.NONE;
               super.dragStop(effect);
            }
            else
            {
               locked = false;
               this.sellItem($info);
            }
         }
         else if(effect.action == DragEffect.SPLIT && effect.target == null)
         {
            locked = false;
         }
         else if(effect.target is FarmFieldBlock)
         {
            locked = false;
            if($info.Property1 != "31")
            {
               this.sellItem();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.beadCanntDestory"));
            }
         }
         else
         {
            super.dragStop(effect);
         }
      }
      
      public function dragCountStart(count:int) : void
      {
         var info:InventoryItemInfo = null;
         var action:String = null;
         if(_info && !locked && stage && count != 0)
         {
            info = this.itemInfo;
            action = DragEffect.MOVE;
            if(count != this.itemInfo.Count)
            {
               info = new InventoryItemInfo();
               info.ItemID = this.itemInfo.ItemID;
               info.BagType = this.itemInfo.BagType;
               info.Place = this.itemInfo.Place;
               info.IsBinds = this.itemInfo.IsBinds;
               info.BeginDate = this.itemInfo.BeginDate;
               info.ValidDate = this.itemInfo.ValidDate;
               info.Count = count;
               info.NeedSex = this.itemInfo.NeedSex;
               action = DragEffect.SPLIT;
            }
            if(DragManager.startDrag(this,info,createDragImg(),stage.mouseX,stage.mouseY,action))
            {
               locked = true;
            }
         }
      }
      
      public function splitItem(count:int) : InventoryItemInfo
      {
         var info:InventoryItemInfo = null;
         if(_info && !locked && stage && count != 0)
         {
            info = this.itemInfo;
            if(count != this.itemInfo.Count)
            {
               info = new InventoryItemInfo();
               info.ItemID = this.itemInfo.ItemID;
               info.BagType = this.itemInfo.BagType;
               info.Place = this.itemInfo.Place;
               info.IsBinds = this.itemInfo.IsBinds;
               info.BeginDate = this.itemInfo.BeginDate;
               info.ValidDate = this.itemInfo.ValidDate;
               info.Count = count;
               info.NeedSex = this.itemInfo.NeedSex;
            }
         }
         return info;
      }
      
      public function sellItem($info:InventoryItemInfo = null) : void
      {
         if(EquipType.isValuableEquip(info))
         {
            if(!PlayerManager.Instance.Self.bagPwdState)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.SellGoodsBtn.CantSellEquip1"));
               return;
            }
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               BagLockedController.Instance.addEventListener(SetPassEvent.CANCELBTN,this.__cancelBtn);
               return;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.SellGoodsBtn.CantSellEquip1"));
         }
         else if(EquipType.isPetSpeciallFood(info))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.sell.CanNotSell"));
         }
         else
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            this.showSellFrame($info);
         }
      }
      
      private function showSellFrame($info:InventoryItemInfo) : void
      {
         if(this._sellFrame == null)
         {
            this._sellFrame = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame");
            this._sellFrame.itemInfo = $info;
            this._sellFrame.addEventListener(SellGoodsFrame.CANCEL,this.disposeSellFrame);
            this._sellFrame.addEventListener(SellGoodsFrame.OK,this.disposeSellFrame);
         }
         LayerManager.Instance.addToLayer(this._sellFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function disposeSellFrame(event:Event) : void
      {
         if(Boolean(this._sellFrame))
         {
            this._sellFrame.dispose();
            this._sellFrame.removeEventListener(SellGoodsFrame.CANCEL,this.disposeSellFrame);
            this._sellFrame.removeEventListener(SellGoodsFrame.OK,this.disposeSellFrame);
         }
         this._sellFrame = null;
      }
      
      protected function __onCellResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onCellResponse);
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(EquipType.isHealStone(info))
            {
               if(PlayerManager.Instance.Self.Grade >= int(info.Property1))
               {
                  this.sendDefy();
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.HealStone.ErrorGrade",info.Property1));
               }
            }
            else
            {
               this.sendDefy();
            }
         }
      }
      
      private function getAlertInfo() : AlertInfo
      {
         var result:AlertInfo = new AlertInfo();
         result.autoDispose = true;
         result.showSubmit = true;
         result.showCancel = true;
         result.enterEnable = true;
         result.escEnable = true;
         result.moveEnable = false;
         result.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         result.data = LanguageMgr.GetTranslation("tank.view.bagII.SellGoodsBtn.sure").replace("{0}",InventoryItemInfo(_info).Count * _info.ReclaimValue + (_info.ReclaimType == 1 ? LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.gold") : (_info.ReclaimType == 2 ? LanguageMgr.GetTranslation("tank.gameover.takecard.gifttoken") : "")));
         return result;
      }
      
      private function confirmCancel() : void
      {
         locked = false;
      }
      
      public function get place() : int
      {
         return this._place;
      }
      
      public function get itemInfo() : InventoryItemInfo
      {
         return _info as InventoryItemInfo;
      }
      
      public function replaceBg(bg:Sprite) : void
      {
         _bg = bg;
      }
      
      public function setCount(num:int) : void
      {
         if(Boolean(this._tbxCount))
         {
            this._tbxCount.text = String(num);
            this._tbxCount.visible = true;
            this._tbxCount.x = _contentWidth - this._tbxCount.width;
            this._tbxCount.y = _contentHeight - this._tbxCount.height;
            addChild(this._tbxCount);
         }
      }
      
      public function refreshTbxPos() : void
      {
         this._tbxCount.x = _pic.x + _contentWidth - this._tbxCount.width - 4;
         this._tbxCount.y = _pic.y + _contentHeight - this._tbxCount.height - 2;
      }
      
      public function setCountNotVisible() : void
      {
         if(Boolean(this._tbxCount))
         {
            this._tbxCount.visible = false;
         }
      }
      
      public function updateCount() : void
      {
         if(Boolean(this._tbxCount))
         {
            if(_info && this.itemInfo && this.itemInfo.MaxCount > 1)
            {
               this._tbxCount.text = String(this.itemInfo.Count);
               this._tbxCount.visible = true;
               addChild(this._tbxCount);
            }
            else
            {
               this._tbxCount.visible = false;
            }
         }
      }
      
      public function checkOverDate() : void
      {
         if(Boolean(this._bgOverDate))
         {
            if(Boolean(this.itemInfo) && this.itemInfo.getRemainDate() <= 0)
            {
               this._bgOverDate.visible = true;
               addChild(this._bgOverDate);
               this.grayPic();
            }
            else
            {
               this._bgOverDate.visible = false;
               this.lightPic();
            }
         }
      }
      
      public function grayPic() : void
      {
         _pic.filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
      }
      
      public function lightPic() : void
      {
         if(Boolean(_pic))
         {
            _pic.filters = [];
         }
      }
      
      public function set BGVisible(value:Boolean) : void
      {
         _bg.visible = value;
      }
      
      private function __cancelBtn(event:SetPassEvent) : void
      {
         BagLockedController.Instance.removeEventListener(SetPassEvent.CANCELBTN,this.__cancelBtn);
         this.disposeSellFrame(null);
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._isUsedBitmap))
         {
            ObjectUtils.disposeObject(this._isUsedBitmap);
         }
         this._isUsedBitmap = null;
         if(Boolean(this._enchantMc))
         {
            this._enchantMc.stop();
         }
         ObjectUtils.disposeObject(this._enchantMc);
         this._enchantMc = null;
         if(Boolean(this._tbxCount))
         {
            ObjectUtils.disposeObject(this._tbxCount);
         }
         this._tbxCount = null;
         if(Boolean(this._bgOverDate))
         {
            ObjectUtils.disposeObject(this._bgOverDate);
         }
         this._bgOverDate = null;
         if(Boolean(this._cellMouseOverBg))
         {
            ObjectUtils.disposeObject(this._cellMouseOverBg);
         }
         this._cellMouseOverBg = null;
         if(Boolean(this._cellMouseOverFormer))
         {
            ObjectUtils.disposeObject(this._cellMouseOverFormer);
         }
         this._cellMouseOverFormer = null;
         super.dispose();
      }
   }
}

