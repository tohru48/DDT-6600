package hall.tasktrack
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.data.quest.QuestItemReward;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import quest.QuestDescTextAnalyz;
   import quest.QuestRewardCell;
   
   public class HallTaskManuGetView extends Sprite implements Disposeable
   {
      
      private var _info:QuestInfo;
      
      private var _closeBtn:SimpleBitmapButton;
      
      private var _getBtn:SimpleBitmapButton;
      
      public function HallTaskManuGetView(info:QuestInfo)
      {
         super();
         this._info = info;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var bg:MovieClip = ComponentFactory.Instance.creat("asset.hall.taskTrack.manuGetView.bg");
         var titleTxt:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("hall.taskManuGetView.titleTxt");
         titleTxt.text = LanguageMgr.GetTranslation("hall.taskManuGetView.titleTxt");
         var descTxt:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("hall.taskManuGetView.descTxt");
         descTxt.htmlText = QuestDescTextAnalyz.start(this._info.Detail);
         addChild(bg);
         addChild(titleTxt);
         addChild(descTxt);
         this.initAwardNum();
         this.initAwardItem();
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("hall.taskManuGetView.closeBtn");
         this._getBtn = ComponentFactory.Instance.creatComponentByStylename("hall.taskManuGetView.getBtn");
         addChild(this._closeBtn);
         addChild(this._getBtn);
      }
      
      private function checkDescTxt(txt:FilterFrameText) : void
      {
         var tmp:String = null;
         var len:int = 0;
         var count:int = 0;
         if(txt.textHeight > txt.height)
         {
            tmp = txt.text;
            len = tmp.length;
            count = 1;
            while(txt.textHeight > txt.height)
            {
               txt.text = tmp.substr(0,len - count) + "...";
               count++;
               if(count > 500)
               {
                  break;
               }
            }
         }
      }
      
      private function initAwardNum() : void
      {
         var posTitleList:Array = null;
         var posValueList:Array = null;
         var posIndex:int = 0;
         var expTitleTxt:FilterFrameText = null;
         var expValueTxt:FilterFrameText = null;
         var goldTitleTxt:FilterFrameText = null;
         var goldValueTxt:FilterFrameText = null;
         var medalTitleTxt:FilterFrameText = null;
         var medalValueTxt:FilterFrameText = null;
         posTitleList = [new Point(237,115),new Point(321,115),new Point(405,115)];
         posValueList = [new Point(272,116),new Point(355,116),new Point(438,116)];
         posIndex = 0;
         if(this._info.RewardGP > 0)
         {
            expTitleTxt = ComponentFactory.Instance.creatComponentByStylename("hall.taskManuGetView.awardNumTitleTxt");
            expTitleTxt.text = LanguageMgr.GetTranslation("exp");
            expValueTxt = ComponentFactory.Instance.creatComponentByStylename("hall.taskManuGetView.awardNumValueTxt");
            expValueTxt.text = this._info.RewardGP.toString();
            expTitleTxt.x = posTitleList[posIndex].x;
            expTitleTxt.y = posTitleList[posIndex].y;
            expValueTxt.x = posValueList[posIndex].x;
            expValueTxt.y = posValueList[posIndex].y;
            addChild(expTitleTxt);
            addChild(expValueTxt);
            posIndex++;
         }
         if(this._info.RewardGold > 0)
         {
            goldTitleTxt = ComponentFactory.Instance.creatComponentByStylename("hall.taskManuGetView.awardNumTitleTxt");
            goldTitleTxt.text = LanguageMgr.GetTranslation("gold");
            goldValueTxt = ComponentFactory.Instance.creatComponentByStylename("hall.taskManuGetView.awardNumValueTxt");
            goldValueTxt.text = this._info.RewardGold.toString();
            goldTitleTxt.x = posTitleList[posIndex].x;
            goldTitleTxt.y = posTitleList[posIndex].y;
            goldValueTxt.x = posValueList[posIndex].x;
            goldValueTxt.y = posValueList[posIndex].y;
            addChild(goldTitleTxt);
            addChild(goldValueTxt);
            posIndex++;
         }
         if(this._info.RewardBindMoney > 0)
         {
            medalTitleTxt = ComponentFactory.Instance.creatComponentByStylename("hall.taskManuGetView.awardNumTitleTxt");
            medalTitleTxt.text = LanguageMgr.GetTranslation("newDdtMoney");
            medalValueTxt = ComponentFactory.Instance.creatComponentByStylename("hall.taskManuGetView.awardNumValueTxt");
            medalValueTxt.text = this._info.RewardBindMoney.toString();
            medalTitleTxt.x = posTitleList[posIndex].x;
            medalTitleTxt.y = posTitleList[posIndex].y;
            medalValueTxt.x = posValueList[posIndex].x;
            medalValueTxt.y = posValueList[posIndex].y;
            addChild(medalTitleTxt);
            addChild(medalValueTxt);
            posIndex++;
         }
      }
      
      private function initAwardItem() : void
      {
         var temp:QuestItemReward = null;
         var tinfo:InventoryItemInfo = null;
         var item:QuestRewardCell = null;
         var posIndex:int = 0;
         for each(temp in this._info.itemRewards)
         {
            tinfo = new InventoryItemInfo();
            tinfo.TemplateID = temp.itemID;
            ItemManager.fill(tinfo);
            tinfo.ValidDate = temp.ValidateTime;
            tinfo.IsJudge = true;
            tinfo.IsBinds = temp.isBind;
            tinfo.AttackCompose = temp.AttackCompose;
            tinfo.DefendCompose = temp.DefendCompose;
            tinfo.AgilityCompose = temp.AgilityCompose;
            tinfo.LuckCompose = temp.LuckCompose;
            tinfo.StrengthenLevel = temp.StrengthenLevel;
            if(EquipType.isMagicStone(tinfo.CategoryID))
            {
               tinfo.Level = tinfo.StrengthenLevel;
               tinfo.Attack = tinfo.AttackCompose;
               tinfo.Defence = tinfo.DefendCompose;
               tinfo.Agility = tinfo.AgilityCompose;
               tinfo.Luck = tinfo.LuckCompose;
               tinfo.MagicAttack = temp.MagicAttack;
               tinfo.MagicDefence = temp.MagicDefence;
            }
            tinfo.Count = temp.count[this._info.QuestLevel - 1];
            if(!(0 != tinfo.NeedSex && this.getSexByInt(PlayerManager.Instance.Self.Sex) != tinfo.NeedSex))
            {
               if(!temp.isOptional)
               {
                  item = new QuestRewardCell(false);
                  item.addChildAt(ComponentFactory.Instance.creatBitmap("asset.hall.taskTrack.manuGetView.cellBg"),0);
                  item.info = tinfo;
                  item.x = 388 - 56 * posIndex;
                  item.y = 140;
                  addChild(item);
                  posIndex++;
               }
            }
         }
      }
      
      private function initEvent() : void
      {
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.closeClickHandler,false,0,true);
         this._getBtn.addEventListener(MouseEvent.CLICK,this.getClickHandler,false,0,true);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QUEST_MANU_GET,this.questManuGetHandler);
      }
      
      private function questManuGetHandler(event:CrazyTankSocketEvent) : void
      {
         this.dispose();
      }
      
      private function closeClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function getClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendQuestManuGet(this._info.id);
      }
      
      private function getSexByInt(Sex:Boolean) : int
      {
         return Sex ? 1 : 2;
      }
      
      private function removeEvent() : void
      {
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.closeClickHandler);
         this._getBtn.removeEventListener(MouseEvent.CLICK,this.getClickHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.QUEST_MANU_GET,this.questManuGetHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._info = null;
         this._closeBtn = null;
         this._getBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

