package petsBag.petsAdvanced
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import hall.event.NewHallEvent;
   import petsBag.data.PetsFormData;
   import petsBag.event.PetItemEvent;
   import road7th.comm.PackageIn;
   
   public class PetsFormView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _shiner:Bitmap;
      
      private var _lifeGuard:FilterFrameText;
      
      private var _absorbHurt:FilterFrameText;
      
      private var _prePageBtn:SimpleBitmapButton;
      
      private var _nextPageBtn:SimpleBitmapButton;
      
      private var _currentPageInput:Scale9CornerImage;
      
      private var _currentPage:FilterFrameText;
      
      private var _page:int = 1;
      
      private var _petsVec:Vector.<PetsFormPetsItem>;
      
      public function PetsFormView()
      {
         super();
         this.initData();
         this.initView();
         this.initEvent();
         this.sendPkg();
      }
      
      private function sendPkg() : void
      {
         SocketManager.Instance.out.sendPetFormInfo();
      }
      
      private function initData() : void
      {
         this._petsVec = new Vector.<PetsFormPetsItem>();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("petsBag.form.bg");
         addChild(this._bg);
         this._lifeGuard = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.lifeGuardText");
         addChild(this._lifeGuard);
         this._absorbHurt = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.lifeGuardText");
         PositionUtils.setPos(this._absorbHurt,"petsBag.form.absorbHurtPos");
         addChild(this._absorbHurt);
         this._prePageBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.prePageBtn");
         addChild(this._prePageBtn);
         this._nextPageBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.nextPageBtn");
         addChild(this._nextPageBtn);
         this._currentPageInput = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.currentPageInput");
         addChild(this._currentPageInput);
         this._currentPage = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.currentPage");
         addChild(this._currentPage);
      }
      
      private function creatPetsView() : void
      {
         var petsItem:PetsFormPetsItem = null;
         var info:PetsFormData = null;
         var list:Vector.<PetsFormData> = null;
         for(var i:int = 0; i < 6; i++)
         {
            petsItem = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.PetsFormPetsItem");
            if(i < 3)
            {
               petsItem.x = 34 + 180 * i;
               petsItem.y = 95;
            }
            else
            {
               petsItem.x = 34 + 180 * (i - 3);
               petsItem.y = 243;
            }
            info = null;
            list = PetsAdvancedManager.Instance.formDataList;
            if(i < PetsAdvancedManager.Instance.formDataList.length)
            {
               info = PetsAdvancedManager.Instance.formDataList[i + (this._page - 1) * 6];
               if(info.TemplateID == PlayerManager.Instance.Self.PetsID)
               {
                  info.ShowBtn = 2;
               }
            }
            petsItem.setInfo(i,info);
            petsItem.addEventListener(PetItemEvent.ITEM_CLICK,this.__onClickPetsItem);
            addChild(petsItem);
            this._petsVec.push(petsItem);
         }
         this._shiner = ComponentFactory.Instance.creat("petsBag.form.clickPets");
         this.setShinerPos(0);
         addChild(this._shiner);
         this.setItemInfo();
      }
      
      protected function __onClickPetsItem(event:PetItemEvent) : void
      {
         var id:int = int(event.data.id);
         this.setShinerPos(id);
      }
      
      private function setShinerPos(id:int) : void
      {
         this._shiner.x = this._petsVec[id].x - 4;
         this._shiner.y = this._petsVec[id].y - 4;
      }
      
      private function setItemInfo() : void
      {
         var healthNum:int = 0;
         var damageReduce:int = 0;
         var list:Vector.<PetsFormData> = PetsAdvancedManager.Instance.formDataList;
         for(var i:int = 0; i < list.length; i++)
         {
            if(Boolean(list[i]) && list[i].State == 1)
            {
               healthNum += list[i].HeathUp;
               damageReduce += list[i].DamageReduce;
            }
         }
         this._lifeGuard.text = LanguageMgr.GetTranslation("petsBag.form.petsListGuardTxt",healthNum);
         this._absorbHurt.text = LanguageMgr.GetTranslation("petsBag.form.petsabsorbHurtTxt",damageReduce);
      }
      
      private function initEvent() : void
      {
         this._prePageBtn.addEventListener(MouseEvent.CLICK,this.__onPrePageClick);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__onNextPageClick);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_FORMINFO,this.__onGetPetsFormInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_FOLLOW,this.__onPetsFollowOrCall);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_WAKE,this.__onPetsWake);
      }
      
      protected function __onPrePageClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(this._page > 1)
         {
            --this._page;
            this.setPageInfo();
         }
      }
      
      protected function __onNextPageClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(6 * this._page < PetsAdvancedManager.Instance.formDataList.length)
         {
            ++this._page;
            this.setPageInfo();
         }
      }
      
      private function setPageInfo() : void
      {
         var index:int = 0;
         var info:PetsFormData = null;
         var list:Vector.<PetsFormData> = null;
         for(var i:int = 0; i < this._petsVec.length; i++)
         {
            index = 6 * (this._page - 1) + i;
            info = null;
            list = PetsAdvancedManager.Instance.formDataList;
            if(index < PetsAdvancedManager.Instance.formDataList.length)
            {
               info = PetsAdvancedManager.Instance.formDataList[index];
            }
            this._petsVec[i].setInfo(i,info);
         }
         this._currentPage.text = this._page + "";
      }
      
      protected function __onGetPetsFormInfo(event:CrazyTankSocketEvent) : void
      {
         var tempId:int = 0;
         var index:int = 0;
         var pkg:PackageIn = event.pkg;
         var num:int = pkg.readInt();
         for(var i:int = 0; i < num; i++)
         {
            tempId = pkg.readInt();
            index = PetsAdvancedManager.Instance.getFormDataIndexByTempId(tempId);
            PetsAdvancedManager.Instance.formDataList[index].State = 1;
            PetsAdvancedManager.Instance.formDataList[index].ShowBtn = 1;
         }
         this.creatPetsView();
      }
      
      protected function __onPetsWake(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var tempId:int = pkg.readInt();
         var index:int = PetsAdvancedManager.Instance.getFormDataIndexByTempId(tempId);
         PetsAdvancedManager.Instance.formDataList[index].State = 1;
         this.resetItemInfo(tempId,1,index);
         for(var i:int = 0; i < this._petsVec.length; i++)
         {
            if(Boolean(this._petsVec[i].info))
            {
               if(this._petsVec[i].info.TemplateID == tempId)
               {
                  this._petsVec[i].addPetBitmap(PetsAdvancedManager.Instance.formDataList[index].Appearance);
                  break;
               }
            }
         }
      }
      
      protected function __onPetsFollowOrCall(event:CrazyTankSocketEvent) : void
      {
         var index:int = 0;
         var pkg:PackageIn = event.pkg;
         var flag:Boolean = pkg.readBoolean();
         var tempId:int = pkg.readInt();
         if(tempId != -1)
         {
            index = PetsAdvancedManager.Instance.getFormDataIndexByTempId(tempId);
            this.resetItemInfo(tempId,flag ? 2 : 1,index);
            PlayerManager.Instance.Self.PetsID = flag ? tempId : -1;
            PlayerManager.Instance.dispatchEvent(new NewHallEvent(NewHallEvent.SHOWPETS,null,[flag,PetsAdvancedManager.Instance.formDataList[index].Resource]));
            if(flag)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("petsBag.form.petsFollowStateTxt"));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("petsBag.form.petsCallBackTxt"));
            }
         }
      }
      
      private function resetItemInfo(tempId:int, showBtn:int, index:int) : void
      {
         this.setItemInfo();
         PetsAdvancedManager.Instance.formDataList[index].ShowBtn = showBtn;
         for(var i:int = 0; i < this._petsVec.length; i++)
         {
            if(Boolean(this._petsVec[i].info))
            {
               if(this._petsVec[i].info.TemplateID == tempId)
               {
                  this._petsVec[i].setInfo(i,PetsAdvancedManager.Instance.formDataList[index]);
               }
               else if(this._petsVec[i].showBtn == 2)
               {
                  this._petsVec[i].showBtn = 1;
               }
            }
         }
      }
      
      private function removeEvent() : void
      {
         this._prePageBtn.removeEventListener(MouseEvent.CLICK,this.__onPrePageClick);
         this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__onNextPageClick);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PET_FORMINFO,this.__onGetPetsFormInfo);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PET_FOLLOW,this.__onPetsFollowOrCall);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PET_WAKE,this.__onPetsWake);
      }
      
      private function deletePets() : void
      {
         for(var i:int = 0; i < this._petsVec.length; i++)
         {
            if(Boolean(this._petsVec[i]))
            {
               this._petsVec[i].removeEventListener(PetItemEvent.ITEM_CLICK,this.__onClickPetsItem);
               this._petsVec[i].dispose();
               this._petsVec[i] = null;
            }
         }
         this._petsVec.length = 0;
         this._petsVec = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.deletePets();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._shiner))
         {
            ObjectUtils.disposeObject(this._shiner);
            this._shiner = null;
         }
         if(Boolean(this._lifeGuard))
         {
            this._lifeGuard.dispose();
            this._lifeGuard = null;
         }
         if(Boolean(this._absorbHurt))
         {
            this._absorbHurt.dispose();
            this._absorbHurt = null;
         }
         if(Boolean(this._prePageBtn))
         {
            this._prePageBtn.dispose();
            this._prePageBtn = null;
         }
         if(Boolean(this._nextPageBtn))
         {
            this._nextPageBtn.dispose();
            this._nextPageBtn = null;
         }
         if(Boolean(this._currentPageInput))
         {
            this._currentPageInput.dispose();
            this._currentPageInput = null;
         }
         if(Boolean(this._currentPage))
         {
            this._currentPage.dispose();
            this._currentPage = null;
         }
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.removeChildAllChildren(this);
      }
   }
}

