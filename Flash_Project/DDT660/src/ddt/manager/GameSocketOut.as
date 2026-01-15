package ddt.manager
{
   import AvatarCollection.AvatarCollectionPackageType;
   import DDPlay.DDPlayType;
   import baglocked.BagLockedController;
   import boguAdventure.model.BoguAdventureType;
   import bombKing.data.BombKingType;
   import calendar.view.goodsExchange.SendGoodsExchangeInfo;
   import cardSystem.model.CardModel;
   import catchInsect.data.CatchInsectPackageType;
   import catchbeast.date.CatchBeastPackageType;
   import chickActivation.ChickActivationType;
   import christmas.data.ChristmasPackageType;
   import cloudBuyLottery.model.CloudBuyLotteryPackageType;
   import collectionTask.event.CollectionTaskEvent;
   import consortionBattle.ConsBatPackageType;
   import cryptBoss.CryptBossEvent;
   import ddt.Version;
   import ddt.data.AccountInfo;
   import ddt.data.BagInfo;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.socket.AcademyPackageType;
   import ddt.data.socket.ActivityPackageType;
   import ddt.data.socket.BattleGoundPackageType;
   import ddt.data.socket.CampPackageType;
   import ddt.data.socket.ChargePackageType;
   import ddt.data.socket.ChurchPackageType;
   import ddt.data.socket.ConsortiaPackageType;
   import ddt.data.socket.CrazyTankPackageType;
   import ddt.data.socket.EliteGamePackageType;
   import ddt.data.socket.FarmPackageType;
   import ddt.data.socket.FightSpiritPackageType;
   import ddt.data.socket.GameRoomPackageType;
   import ddt.data.socket.HotSpringPackageType;
   import ddt.data.socket.IMPackageType;
   import ddt.data.socket.MagpieBridgePackageType;
   import ddt.data.socket.NewHallPackageType;
   import ddt.data.socket.RechargePackageType;
   import ddt.data.socket.RegressPackageType;
   import ddt.data.socket.RingStationPackageType;
   import ddt.data.socket.SearchGoodsPackageType;
   import ddt.data.socket.SevenDayTargetPackageType;
   import ddt.data.socket.TreasurePackageType;
   import ddt.data.socket.ePackageType;
   import ddt.utils.CrytoUtils;
   import dragonBoat.DragonBoatPackageType;
   import drgnBoat.DrgnBoatPackageType;
   import email.manager.MailManager;
   import entertainmentMode.data.EntertainmentPackageType;
   import escort.EscortPackageType;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   import flowerGiving.data.FlowerGivingType;
   import foodActivity.event.FoodActivityEvent;
   import gemstone.info.GemstnoeSendInfo;
   import godsRoads.data.GodsRoadsPkgType;
   import groupPurchase.GroupPurchasePackageType;
   import growthPackage.GrowthPackageType;
   import guildMemberWeek.data.GuildMemberWeekPackageType;
   import halloween.data.HalloweenType;
   import horse.HorsePackageType;
   import horseRace.controller.HorseRaceManager;
   import itemActivityGift.ItemActivityGiftType;
   import labyrinth.data.LabyrinthPackageType;
   import lanternriddles.data.LanternriddlesPackageType;
   import lightRoad.data.LightRoadPackageType;
   import magicHouse.MagicHousePackageType;
   import magicStone.data.MagicStoneType;
   import newChickenBox.model.NewChickenBoxPackageType;
   import newChickenBox.view.NewChickenBoxItem;
   import newYearRice.data.NewYearRicePackageType;
   import playerDress.data.PlayerDressType;
   import quest.TrusteeshipPackageType;
   import rescue.data.RescueType;
   import road7th.comm.ByteSocket;
   import road7th.comm.PackageOut;
   import road7th.math.randRange;
   import sevenDouble.SevenDoublePackageType;
   import superWinner.data.SuperWinnerPackageType;
   import trainer.controller.WeakGuildManager;
   import treasureLost.data.TreasureLostPackageType;
   import treasurePuzzle.data.TreasurePuzzlePackageType;
   import witchBlessing.data.WitchBlessingPackageType;
   import wonderfulActivity.data.SendGiftInfo;
   import worldBossHelper.data.WorldBossHelperTypeData;
   import worldboss.model.WorldBossGamePackageType;
   import worldboss.model.WorldBossPackageType;
   import zodiac.ZodiacPackageType;
   import guardCore.GuardCorePackageType;
   
   public class GameSocketOut
   {
      
      private var _socket:ByteSocket;
      
      public function GameSocketOut(socket:ByteSocket)
      {
         super();
         this._socket = socket;
      }
      
      public function sendLogin(acc:AccountInfo) : void
      {
         this._socket.resetKey();
         var date:Date = new Date();
         var temp:ByteArray = new ByteArray();
         var fsm_key:int = randRange(100,10000);
         temp.writeShort(date.fullYearUTC);
         temp.writeByte(date.monthUTC + 1);
         temp.writeByte(date.dateUTC);
         temp.writeByte(date.hoursUTC);
         temp.writeByte(date.minutesUTC);
         temp.writeByte(date.secondsUTC);
         var key:Array = [Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255)];
         for(var i:int = 0; i < key.length; i++)
         {
            temp.writeByte(key[i]);
         }
         temp.writeUTFBytes(acc.Account + "," + acc.Password);
         temp = CrytoUtils.rsaEncry5(acc.Key,temp);
         temp.position = 0;
         var pkg:PackageOut = new PackageOut(ePackageType.LOGIN);
         pkg.writeInt(Version.Build);
         pkg.writeInt(DesktopManager.Instance.desktopType);
         pkg.writeBytes(temp);
         this.sendPackage(pkg);
         this._socket.setKey(key);
      }
      
      public function sendWeeklyClick() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WEEKLY_CLICK_CNT);
         this.sendPackage(pkg);
      }
      
      public function sendGameLogin(hallType:int, isRnd:int, roomId:int = -1, pass:String = "", isInvite:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.GAME_ROOM_LOGIN);
         pkg.writeBoolean(isInvite);
         pkg.writeInt(hallType);
         pkg.writeInt(isRnd);
         if(isRnd == -1)
         {
            pkg.writeInt(roomId);
            pkg.writeUTF(pass);
         }
         this.sendPackage(pkg);
      }
      
      public function sendFastInviteCall() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.FAST_INVITE_CALL);
         this.sendPackage(pkg);
      }
      
      public function sendFastAuctionCall() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.FAST_INVITE_CALL);
         this.sendPackage(pkg);
      }
      
      public function sendSceneLogin(hellType:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SCENE_LOGIN);
         pkg.writeInt(hellType);
         this.sendPackage(pkg);
      }
      
      public function sendGameStyle(style:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.GAME_PICKUP_STYLE);
         pkg.writeInt(style);
         this.sendPackage(pkg);
      }
      
      public function sendDailyAward(getWay:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.DAILY_AWARD);
         pkg.writeInt(getWay);
         this.sendPackage(pkg);
      }
      
      public function sendDaySign(date:Date) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.DAILY_AWARD);
         pkg.writeInt(6);
         pkg.writeDate(date);
         this.sendPackage(pkg);
      }
      
      public function sendSignAward(signCount:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GET_SIGNAWARD);
         pkg.writeInt(signCount);
         this.sendPackage(pkg);
      }
      
      public function sendBuyGoods(items:Array, types:Array, colors:Array, places:Array, dresses:Array, skin:Array = null, buyFrom:int = 0, goodsTypes:Array = null, arr:Array = null) : void
      {
         var tmpArr:Array = null;
         if(items.length > 50)
         {
            if(Boolean(arr) && arr.length > 50)
            {
               tmpArr = arr.splice(0,50);
            }
            else
            {
               tmpArr = arr;
            }
            if(skin == null)
            {
               this.sendBuyGoods(items.splice(0,50),types.splice(0,50),colors.splice(0,50),places.splice(0,50),dresses.splice(0,50),null,buyFrom,goodsTypes,tmpArr);
            }
            else
            {
               this.sendBuyGoods(items.splice(0,50),types.splice(0,50),colors.splice(0,50),places.splice(0,50),dresses.splice(0,50),skin.splice(0,50),buyFrom,goodsTypes,tmpArr);
            }
            this.sendBuyGoods(items,types,colors,places,dresses,skin,buyFrom,goodsTypes,arr);
            return;
         }
         var pkg:PackageOut = new PackageOut(ePackageType.BUY_GOODS);
         var count:int = int(items.length);
         pkg.writeInt(count);
         for(var i:uint = 0; i < count; i++)
         {
            if(!goodsTypes)
            {
               pkg.writeInt(1);
            }
            else
            {
               pkg.writeInt(goodsTypes[i]);
            }
            pkg.writeInt(items[i]);
            pkg.writeInt(types[i]);
            pkg.writeUTF(colors[i]);
            pkg.writeBoolean(dresses[i]);
            if(skin == null)
            {
               pkg.writeUTF("");
            }
            else
            {
               pkg.writeUTF(skin[i]);
            }
            pkg.writeInt(places[i]);
            if(Boolean(arr))
            {
               pkg.writeBoolean(arr[i]);
            }
            else
            {
               pkg.writeBoolean(false);
            }
         }
         pkg.writeInt(buyFrom);
         this.sendPackage(pkg);
      }
      
      public function sendButTransnationalGoods(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TRANSNATIONAL_BUYGOODS);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendBuyProp(id:int, bool:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PROP_BUY);
         pkg.writeInt(id);
         pkg.writeBoolean(bool);
         this.sendPackage(pkg);
      }
      
      public function sendSellProp(id:int, GoodsID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PROP_SELL);
         pkg.writeInt(id);
         pkg.writeInt(GoodsID);
         this.sendPackage(pkg);
      }
      
      public function sendQuickBuyGoldBox(buyNumber:int, bool:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.BUY_QUICK_GOLDBOX);
         pkg.writeInt(buyNumber);
         pkg.writeBoolean(bool);
         this.sendPackage(pkg);
      }
      
      public function sendBuyGiftBag(type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.BUY_GIFTBAG);
         pkg.writeInt(type);
         this.sendPackage(pkg);
      }
      
      public function sendPresentGoods(ids:Array, types:Array, colors:Array, goodTypes:Array, msg:String, nick:String, skin:Array = null, bools:Array = null) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GOODS_PRESENT);
         var count:int = int(ids.length);
         pkg.writeUTF(msg);
         pkg.writeUTF(nick);
         pkg.writeInt(count);
         for(var i:uint = 0; i < count; i++)
         {
            pkg.writeInt(ids[i]);
            pkg.writeInt(types[i]);
            pkg.writeUTF(colors[i]);
            if(skin == null)
            {
               pkg.writeUTF("");
            }
            else
            {
               pkg.writeUTF(skin[i]);
            }
            pkg.writeInt(goodTypes[i]);
         }
         this.sendPackage(pkg);
      }
      
      public function sendGoodsContinue(data:Array) : void
      {
         var count:int = int(data.length);
         var pkg:PackageOut = new PackageOut(ePackageType.ITEM_CONTINUE);
         pkg.writeInt(count);
         for(var i:uint = 0; i < count; i++)
         {
            pkg.writeByte(data[i][0]);
            pkg.writeInt(data[i][1]);
            pkg.writeInt(data[i][2]);
            pkg.writeByte(data[i][3]);
            pkg.writeBoolean(data[i][4]);
            pkg.writeInt(data[i][5]);
         }
         this.sendPackage(pkg);
      }
      
      public function sendSellGoods(position:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEll_GOODS);
         pkg.writeInt(position);
         this.sendPackage(pkg);
      }
      
      public function sendUpdateGoodsCount() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GOODS_COUNT);
         this.sendPackage(pkg);
      }
      
      public function sendEmail(param:Object) : void
      {
         var i:uint = 0;
         var pkg:PackageOut = new PackageOut(ePackageType.SEND_MAIL);
         pkg.writeUTF(param.NickName);
         pkg.writeUTF(param.Title);
         pkg.writeUTF(param.Content);
         pkg.writeBoolean(param.isPay);
         pkg.writeInt(param.hours);
         for(pkg.writeInt(param.SendedMoney); i < MailManager.Instance.NUM_OF_WRITING_DIAMONDS; )
         {
            if(Boolean(param["Annex" + i]))
            {
               pkg.writeByte(param["Annex" + i].split(",")[0]);
               pkg.writeInt(param["Annex" + i].split(",")[1]);
               pkg.writeInt(param.Count);
            }
            else
            {
               pkg.writeByte(0);
               pkg.writeInt(-1);
               pkg.writeInt(0);
            }
            i++;
         }
         this.sendPackage(pkg);
      }
      
      public function sendUpdateMail(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.UPDATE_MAIL);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendDeleteMail(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.DELETE_MAIL);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function untreadEmail(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MAIL_CANCEL);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendGetMail(emailId:int, type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GET_MAIL_ATTACHMENT);
         pkg.writeInt(emailId);
         pkg.writeByte(type);
         this.sendPackage(pkg);
      }
      
      public function sendPint() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PING);
         this.sendPackage(pkg);
      }
      
      public function sendSuicide(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.SUICIDE);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendKillSelf(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.KILLSELF);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendItemCompose(consortiaState:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ITEM_COMPOSE);
         pkg.writeBoolean(consortiaState);
         this.sendPackage(pkg);
      }
      
      public function sendItemTransfer(transferBefore:Boolean = true, transferAfter:Boolean = true, sBagType:int = 12, sPlace:int = 0, tBagType:int = 12, tPlace:int = 1) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ITEM_TRANSFER);
         pkg.writeBoolean(transferBefore);
         pkg.writeBoolean(transferAfter);
         pkg.writeInt(sBagType);
         pkg.writeInt(sPlace);
         pkg.writeInt(tBagType);
         pkg.writeInt(tPlace);
         this.sendPackage(pkg);
      }
      
      public function sendItemStrength(consortiaState:Boolean, isAllInject:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ITEM_STRENGTHEN);
         pkg.writeBoolean(consortiaState);
         pkg.writeBoolean(isAllInject);
         this.sendPackage(pkg);
      }
      
      public function sendItemExalt() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ITEM_ADVANCE);
         this.sendPackage(pkg);
      }
      
      public function sendItemLianhua(operation:int, count:int, matieria:Array, equipBagType:int, equipPlace:int, luckyBagType:int, luckyPlace:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ITEM_REFINERY);
         pkg.writeInt(operation);
         pkg.writeInt(count);
         for(var i:int = 0; i < matieria.length; i++)
         {
            pkg.writeInt(matieria[i]);
         }
         pkg.writeInt(equipBagType);
         pkg.writeInt(equipPlace);
         pkg.writeInt(luckyBagType);
         pkg.writeInt(luckyPlace);
         this.sendPackage(pkg);
      }
      
      public function sendBeadEquip(pBeadPlace:int, pAimPlace:int) : void
      {
         var vPkg:PackageOut = new PackageOut(ePackageType.RUNE_COMMAND);
         vPkg.writeByte(CrazyTankPackageType.RUNE_MOVEPLACE);
         vPkg.writeInt(pBeadPlace);
         vPkg.writeInt(pAimPlace);
         this.sendPackage(vPkg);
      }
      
      public function sendBeadUpgrade(pSlots:Array) : void
      {
         var o:int = 0;
         var vPkg:PackageOut = new PackageOut(ePackageType.RUNE_COMMAND);
         vPkg.writeByte(CrazyTankPackageType.RUNE_UPGRADE);
         vPkg.writeInt(pSlots.length);
         for each(o in pSlots)
         {
            vPkg.writeInt(o);
         }
         this.sendPackage(vPkg);
      }
      
      public function sendOpenBead(pIndex:int) : void
      {
         var vPkg:PackageOut = new PackageOut(ePackageType.RUNE_COMMAND);
         vPkg.writeByte(CrazyTankPackageType.RUNE_OPENPACKAGE);
         vPkg.writeInt(pIndex);
         this.sendPackage(vPkg);
      }
      
      public function sendBeadLock(pBeadPlace:int) : void
      {
         var vPkg:PackageOut = new PackageOut(ePackageType.RUNE_COMMAND);
         vPkg.writeByte(CrazyTankPackageType.RUNE_LOCK);
         vPkg.writeInt(pBeadPlace);
         this.sendPackage(vPkg);
      }
      
      public function sendBeadOpenHole(pHoleIndex:int, pDrillID:int, num:int = 1) : void
      {
         var vPkg:PackageOut = new PackageOut(ePackageType.RUNE_COMMAND);
         vPkg.writeByte(CrazyTankPackageType.RUNE_OPEN_HOLE);
         vPkg.writeInt(pHoleIndex);
         vPkg.writeInt(pDrillID);
         vPkg.writeInt(num);
         this.sendPackage(vPkg);
      }
      
      public function sendItemEmbedBackout(itemPlace:int, templateID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ITEM_EMBED_BACKOUT);
         pkg.writeInt(itemPlace);
         pkg.writeInt(templateID);
         this.sendPackage(pkg);
      }
      
      public function sendItemOpenFiveSixHole(itemPlace:int, number:int, drill:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.OPEN_FIVE_SIX_HOLE);
         pkg.writeInt(itemPlace);
         pkg.writeInt(number);
         pkg.writeInt(drill);
         this.sendPackage(pkg);
      }
      
      public function sendItemTrend(itemBagType:int, itemPlace:int, propBagType:int, propPlace:int, trendType:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ITEM_TREND);
         pkg.writeInt(itemBagType);
         pkg.writeInt(itemPlace);
         pkg.writeInt(propBagType);
         pkg.writeInt(propPlace);
         pkg.writeInt(trendType);
         this.sendPackage(pkg);
      }
      
      public function sendClearStoreBag() : void
      {
         PlayerManager.Instance.Self.StoreBag.items.clear();
         var pkg:PackageOut = new PackageOut(ePackageType.CLEAR_STORE_BAG);
         this.sendPackage(pkg);
      }
      
      public function sendCheckCode(code:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CHECK_CODE);
         pkg.writeUTF(code);
         this.sendPackage(pkg);
      }
      
      public function sendEquipRetrieve() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.EQUIP_RECYCLE_ITEM);
         this.sendPackage(pkg);
      }
      
      public function sendItemFusion(fusionId:int, count:int, withoutComposeAttr:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ITEM_FUSION);
         pkg.writeInt(fusionId);
         pkg.writeInt(count);
         pkg.writeBoolean(withoutComposeAttr);
         this.sendPackage(pkg);
      }
      
      public function sendSBugle(msg:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.S_BUGLE);
         pkg.writeInt(PlayerManager.Instance.Self.ID);
         pkg.writeUTF(PlayerManager.Instance.Self.NickName);
         pkg.writeUTF(msg);
         this.sendPackage(pkg);
      }
      
      public function sendBBugle(msg:String, templateID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.B_BUGLE);
         pkg.writeInt(templateID);
         pkg.writeInt(PlayerManager.Instance.Self.ID);
         pkg.writeUTF(PlayerManager.Instance.Self.NickName);
         pkg.writeUTF(msg);
         this.sendPackage(pkg);
      }
      
      public function sendCBugle(msg:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.C_BUGLE);
         pkg.writeInt(PlayerManager.Instance.Self.ID);
         pkg.writeUTF(PlayerManager.Instance.Self.NickName);
         pkg.writeUTF(msg);
         this.sendPackage(pkg);
      }
      
      public function sendDefyAffiche(msg:String, bool:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.DEFY_AFFICHE);
         pkg.writeBoolean(bool);
         pkg.writeUTF(msg);
         this.sendPackage(pkg);
      }
      
      public function sendGameMode(style:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.GAME_PICKUP_STYLE);
         pkg.writeInt(style);
         this.sendPackage(pkg);
      }
      
      public function sendAddFriend(nick:String, Relation:int, isSendEmail:Boolean = false, isSameCity:Boolean = false) : void
      {
         if(nick == "")
         {
            return;
         }
         var pkg:PackageOut = new PackageOut(ePackageType.IM_CMD);
         pkg.writeByte(IMPackageType.FRIEND_ADD);
         pkg.writeUTF(nick);
         pkg.writeInt(Relation);
         pkg.writeBoolean(isSendEmail);
         pkg.writeBoolean(isSameCity);
         this.sendPackage(pkg);
      }
      
      public function sendDelFriend(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.IM_CMD);
         pkg.writeByte(IMPackageType.FRIEND_REMOVE);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendFriendState(state:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.IM_CMD);
         pkg.writeByte(IMPackageType.FRIEND_STATE);
         pkg.writeInt(state);
         this.sendPackage(pkg);
      }
      
      public function sendBagLocked(pwd:String, type:int, newPwd:String = "", questionOne:String = "", answerOne:String = "", questionTwo:String = "", answerTwo:String = "") : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.BAG_LOCKED);
         BagLockedController.TEMP_PWD = newPwd != "" ? newPwd : pwd;
         pkg.writeUTF(pwd);
         pkg.writeUTF(newPwd);
         pkg.writeInt(type);
         pkg.writeUTF(questionOne);
         pkg.writeUTF(answerOne);
         pkg.writeUTF(questionTwo);
         pkg.writeUTF(answerTwo);
         this.sendPackage(pkg);
      }
      
      public function sendBagLockedII(psw:String, questionOne:String, answerOne:String, questionTwo:String, answerTwo:String) : void
      {
      }
      
      public function sendConsortiaEquipConstrol(arr:Array) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_EQUIP_CONTROL);
         for(var i:int = 0; i < arr.length; i++)
         {
            pkg.writeInt(arr[i]);
         }
         this.sendPackage(pkg);
      }
      
      public function sendErrorMsg(msg:String) : void
      {
         var pkg:PackageOut = null;
         if(msg.length < 1000)
         {
            pkg = new PackageOut(ePackageType.CLIENT_LOG);
            pkg.writeUTF(msg);
            this.sendPackage(pkg);
         }
      }
      
      public function sendItemOverDue(bagtype:int, place:int) : void
      {
         if(bagtype == -1)
         {
            return;
         }
         var pkg:PackageOut = new PackageOut(ePackageType.ITEM_OVERDUE);
         pkg.writeByte(bagtype);
         pkg.writeInt(place);
         this.sendPackage(pkg);
      }
      
      public function sendHideLayer(categoryid:int, hide:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ITEM_HIDE);
         pkg.writeBoolean(hide);
         pkg.writeInt(categoryid);
         this.sendPackage(pkg);
      }
      
      public function sendQuestManuGet(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.QUEST_MANU_GET);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendQuestAdd(arr:Array) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.QUEST_ADD);
         pkg.writeInt(arr.length);
         for(var i:int = 0; i < arr.length; i++)
         {
            if(arr[i] == 3025)
            {
            }
            pkg.writeInt(arr[i]);
         }
         this.sendPackage(pkg);
      }
      
      public function sendQuestRemove(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.QUEST_REMOVE);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendQuestFinish(id:int, itemId:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.QUEST_FINISH);
         pkg.writeInt(id);
         pkg.writeInt(itemId);
         this.sendPackage(pkg);
      }
      
      public function sendQuestOneToFinish(questId:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.QUEST_ONEKEYFINISH);
         pkg.writeInt(questId);
         this.sendPackage(pkg);
      }
      
      public function sendImproveQuest(questId:int, bool:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.QUEST_LEVEL_UP);
         pkg.writeInt(questId);
         pkg.writeBoolean(bool);
         this.sendPackage(pkg);
      }
      
      public function sendQuestCheck(id:int, conid:int, value:int = 1) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.QUEST_CHECK);
         pkg.writeInt(id);
         pkg.writeInt(conid);
         pkg.writeInt(value);
         this.sendPackage(pkg);
      }
      
      public function sendItemOpenUp(bagtype:int, place:int, count:int = 1, isBand:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ITEM_OPENUP);
         pkg.writeByte(bagtype);
         pkg.writeInt(place);
         pkg.writeInt(count);
         pkg.writeBoolean(isBand);
         this.sendPackage(pkg);
      }
      
      public function sendItemEquip(idOrNickName:*, isUseNickName:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ITEM_EQUIP);
         if(!isUseNickName)
         {
            pkg.writeBoolean(true);
            pkg.writeInt(idOrNickName);
         }
         else if(isUseNickName)
         {
            pkg.writeBoolean(false);
            pkg.writeUTF(idOrNickName);
         }
         this.sendPackage(pkg);
      }
      
      public function sendMateTime(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MATE_ONLINE_TIME);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendPlayerGift(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.USER_GET_GIFTS);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendActivePullDown(id:int, pass:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVE_PULLDOWN);
         pkg.writeInt(id);
         pkg.writeUTF(pass);
         this.sendPackage(pkg);
      }
      
      public function auctionGood(bagType:int, place:int, payType:int, price:int, mouthful:int, validDate:int, count:int, isAuctionBugle:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.AUCTION_ADD);
         pkg.writeByte(bagType);
         pkg.writeInt(place);
         pkg.writeByte(payType);
         pkg.writeInt(price);
         pkg.writeInt(mouthful);
         pkg.writeInt(validDate);
         pkg.writeInt(count);
         pkg.writeBoolean(isAuctionBugle);
         this.sendPackage(pkg);
      }
      
      public function auctionCancelSell(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.AUCTION_DELETE);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function auctionBid(id:int, price:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.AUCTION_UPDATE);
         pkg.writeInt(id);
         pkg.writeInt(price);
         this.sendPackage(pkg);
      }
      
      public function syncStep(id:int, save:Boolean = true) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.USER_ANSWER);
         pkg.writeByte(1);
         pkg.writeInt(id);
         pkg.writeBoolean(save);
         this.sendPackage(pkg);
      }
      
      public function syncWeakStep(id:int) : void
      {
         WeakGuildManager.Instance.setStepFinish(id);
         var pkg:PackageOut = new PackageOut(ePackageType.USER_ANSWER);
         pkg.writeByte(2);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendCreateConsortia(name:String, bool:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_CREATE);
         pkg.writeUTF(name);
         pkg.writeBoolean(bool);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaTryIn(consortiaid:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN);
         pkg.writeInt(consortiaid);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaCancelTryIn() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN);
         pkg.writeInt(0);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaInvate(name:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_INVITE);
         pkg.writeUTF(name);
         this.sendPackage(pkg);
      }
      
      public function sendReleaseConsortiaTask(type:int, bool:Boolean = true, level:int = 1) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_TASK_RELEASE);
         pkg.writeInt(type);
         if(type == 0)
         {
            pkg.writeInt(level);
         }
         else
         {
            pkg.writeBoolean(bool);
         }
         this.sendPackage(pkg);
      }
      
      public function addSpeed(type:int, id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.EVERYDAY_ACTIVEPOINT);
         pkg.writeByte(ActivityPackageType.REUSEMONEYPOINT_COMPLETE);
         pkg.writeInt(type);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaInvatePass(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_INVITE_PASS);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaInvateDelete(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_INVITE_DELETE);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaUpdateDescription(description:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_DESCRIPTION_UPDATE);
         pkg.writeUTF(description);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaUpdatePlacard(placard:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_PLACARD_UPDATE);
         pkg.writeUTF(placard);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaUpdateDuty(dutyid:int, dutyname:String, right:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_DUTY_UPDATE);
         pkg.writeInt(dutyid);
         pkg.writeByte(dutyid == -1 ? 1 : 2);
         pkg.writeUTF(dutyname);
         pkg.writeInt(right);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaUpgradeDuty(dutyid:int, updown:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_DUTY_UPDATE);
         pkg.writeInt(dutyid);
         pkg.writeByte(updown);
         this.sendPackage(pkg);
      }
      
      public function sendConsoritaApplyStatusOut(b:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_APPLY_STATE);
         pkg.writeBoolean(b);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaOut(playerid:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_RENEGADE);
         pkg.writeInt(playerid);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaMemberGrade(id:int, isUpgrade:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_USER_GRADE_UPDATE);
         pkg.writeInt(id);
         pkg.writeBoolean(isUpgrade);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaUserRemarkUpdate(id:int, msg:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_USER_REMARK_UPDATE);
         pkg.writeInt(id);
         pkg.writeUTF(msg);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaDutyDelete(dutyid:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_DUTY_DELETE);
         pkg.writeInt(dutyid);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaTryinPass(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN_PASS);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaTryinDelete(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN_DEL);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendForbidSpeak(id:int, forbid:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_BANCHAT_UPDATE);
         pkg.writeInt(id);
         pkg.writeBoolean(forbid);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaDismiss() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_DISBAND);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaChangeChairman(nickName:String = "") : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_CHAIRMAN_CHAHGE);
         pkg.writeUTF(nickName);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaRichOffer(num:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_RICHES_OFFER);
         pkg.writeInt(num);
         pkg.writeBoolean(false);
         this.sendPackage(pkg);
      }
      
      public function sendDonate(id:int, num:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.DONATE);
         pkg.writeInt(id);
         pkg.writeInt(num);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaLevelUp(type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_LEVEL_UP);
         pkg.writeByte(type);
         this.sendPackage(pkg);
      }
      
      public function sendAirPlane() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.AIRPLANE);
         this.sendPackage(pkg);
      }
      
      public function useDeputyWeapon() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.USE_DEPUTY_WEAPON);
         this.sendPackage(pkg);
      }
      
      public function sendGamePick(bombId:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.PICK);
         pkg.writeInt(bombId);
         this.sendPackage(pkg);
      }
      
      public function sendPetSkill(skillID:int, type:int = 1) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.PET_SKILL);
         pkg.writeInt(skillID);
         pkg.writeInt(type);
         this.sendPackage(pkg);
      }
      
      public function sendPackage(pkg:PackageOut) : void
      {
         this._socket.send(pkg);
      }
      
      public function sendMoveGoods(bagtype:int, place:int, tobagType:int, toplace:int, count:int = 1, allMove:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CHANGE_PLACE_GOODS);
         pkg.writeByte(bagtype);
         pkg.writeInt(place);
         pkg.writeByte(tobagType);
         pkg.writeInt(toplace);
         pkg.writeInt(count);
         pkg.writeBoolean(allMove);
         this.sendPackage(pkg);
      }
      
      public function reclaimGoods(bagtype:int, place:int, count:int = 1) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.REClAIM_GOODS);
         pkg.writeByte(bagtype);
         pkg.writeInt(place);
         pkg.writeInt(count);
         this.sendPackage(pkg);
      }
      
      public function sendMoveGoodsAll(bagType:int, array:Array, startPlace:int, isSegistration:Boolean = false) : void
      {
         if(array.length <= 0)
         {
            return;
         }
         var len:int = int(array.length);
         var pkg:PackageOut = new PackageOut(ePackageType.CHANGE_PLACE_GOODS_ALL);
         pkg.writeBoolean(isSegistration);
         pkg.writeInt(len);
         pkg.writeInt(bagType);
         for(var i:int = 0; i < len; i++)
         {
            pkg.writeInt(array[i].Place);
            pkg.writeInt(i + startPlace);
         }
         this.sendPackage(pkg);
      }
      
      public function sendForSwitch() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ENTHRALL_SWITCH);
         this.sendPackage(pkg);
      }
      
      public function sendCIDCheck() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CID_CHECK);
         this.sendPackage(pkg);
      }
      
      public function sendCIDInfo(name:String, CID:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CID_CHECK);
         pkg.writeBoolean(false);
         pkg.writeUTF(name);
         pkg.writeUTF(CID);
         this.sendPackage(pkg);
      }
      
      public function sendChangeColor(cardBagType:int, cardPlace:int, itemBagType:int, itemPlace:int, color:String, skin:String, templateID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.USE_COLOR_CARD);
         pkg.writeInt(cardBagType);
         pkg.writeInt(cardPlace);
         pkg.writeInt(itemBagType);
         pkg.writeInt(itemPlace);
         pkg.writeUTF(color);
         pkg.writeUTF(skin);
         pkg.writeInt(templateID);
         this.sendPackage(pkg);
      }
      
      public function sendUseCard(bagType:int, cardPlace:int, items:Array, type:int, ignoreBagLock:Boolean = false, bool:Boolean = true, count:int = 1) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CARD_USE);
         pkg.writeInt(bagType);
         pkg.writeInt(cardPlace);
         pkg.writeInt(items.length);
         var len:int = int(items.length);
         for(var i:int = 0; i < len; i++)
         {
            pkg.writeInt(items[i]);
         }
         pkg.writeInt(type);
         pkg.writeBoolean(ignoreBagLock);
         pkg.writeBoolean(bool);
         pkg.writeInt(count);
         this.sendPackage(pkg);
      }
      
      public function sendUseProp(bagType:int, cardPlace:int, items:Array, type:int, ignoreBagLock:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PROP_USE);
         pkg.writeInt(bagType);
         pkg.writeInt(cardPlace);
         pkg.writeInt(items.length);
         var len:int = int(items.length);
         for(var i:int = 0; i < len; i++)
         {
            pkg.writeInt(items[i]);
         }
         pkg.writeInt(type);
         pkg.writeBoolean(ignoreBagLock);
         this.sendPackage(pkg);
      }
      
      public function sendUseChangeColorShell(bagType:int, cardPlace:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.USE_CHANGE_COLOR_SHELL);
         pkg.writeByte(bagType);
         pkg.writeInt(cardPlace);
         this.sendPackage(pkg);
      }
      
      public function sendChangeColorShellTimeOver(bagtype:int, place:int) : void
      {
         if(bagtype == -1)
         {
            return;
         }
         var pkg:PackageOut = new PackageOut(ePackageType.CHANGE_COLOR_OVER_DUE);
         pkg.writeByte(bagtype);
         pkg.writeInt(place);
         this.sendPackage(pkg);
      }
      
      public function sendRouletteBox(bagType:int, place:int, boxId:int = -1) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LOTTERY_OPEN_BOX);
         pkg.writeByte(bagType);
         pkg.writeInt(place);
         pkg.writeInt(boxId);
         this.sendPackage(pkg);
      }
      
      public function sendStartTurn(type:int = 1) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LOTTERY_RANDOM_SELECT);
         pkg.writeInt(type);
         this.sendPackage(pkg);
      }
      
      public function sendFinishRoulette() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LOTTERY_FINISH);
         this.sendPackage(pkg);
      }
      
      public function sendSellAll() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CADDY_SELL_ALL_GOODS);
         this.sendPackage(pkg);
      }
      
      public function sendconverted(isConver:Boolean, totalSorce:int = 0, lotteryScore:int = 0) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CADDY_CONVERTED_ALL);
         pkg.writeBoolean(isConver);
         pkg.writeInt(totalSorce);
         pkg.writeInt(lotteryScore);
         this.sendPackage(pkg);
      }
      
      public function sendExchange() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CADDY_EXCHANGE_ALL);
         this.sendPackage(pkg);
      }
      
      public function sendOpenAll() : void
      {
      }
      
      public function sendOpenDead(bagType:int, place:int, id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LOTTERY_OPEN_BOX);
         pkg.writeByte(bagType);
         pkg.writeInt(place);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendRequestAwards(type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CADDY_GET_AWARDS);
         pkg.writeInt(type);
         this.sendPackage(pkg);
      }
      
      public function sendQequestBadLuck(isOpen:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CADDY_GET_BADLUCK);
         pkg.writeBoolean(isOpen);
         this.sendPackage(pkg);
      }
      
      public function sendQequestLuckky(isOpen:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LUCKSTONE_RANK_LIMIT);
         pkg.writeBoolean(isOpen);
         this.sendPackage(pkg);
      }
      
      public function sendUseReworkName(bagType:int, place:int, newName:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.USE_REWORK_NAME);
         pkg.writeByte(bagType);
         pkg.writeInt(place);
         pkg.writeUTF(newName);
         this.sendPackage(pkg);
      }
      
      public function sendUseConsortiaReworkName(consortiaID:int, bagType:int, place:int, newName:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.USE_CONSORTIA_REWORK_NAME);
         pkg.writeInt(consortiaID);
         pkg.writeByte(bagType);
         pkg.writeInt(place);
         pkg.writeUTF(newName);
         this.sendPackage(pkg);
      }
      
      public function sendValidateMarry(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_STATUS);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendPropose(id:int, text:String, useBugle:Boolean, bool:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_APPLY);
         pkg.writeInt(id);
         pkg.writeUTF(text);
         pkg.writeBoolean(useBugle);
         pkg.writeBoolean(bool);
         this.sendPackage(pkg);
      }
      
      public function sendProposeRespose(result:Boolean, id:int, answerId:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_APPLY_REPLY);
         pkg.writeBoolean(result);
         pkg.writeInt(id);
         pkg.writeInt(answerId);
         this.sendPackage(pkg);
      }
      
      public function sendUnmarry(isPlayMovie:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.DIVORCE_APPLY);
         pkg.writeBoolean(isPlayMovie);
         pkg.writeBoolean(PlayerManager.Instance.merryActivity);
         this.sendPackage(pkg);
      }
      
      public function sendMarryRoomLogin() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_SCENE_LOGIN);
         this.sendPackage(pkg);
      }
      
      public function sendExitMarryRoom() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SCENE_REMOVE_USER);
         this.sendPackage(pkg);
      }
      
      public function sendCreateRoom(roomName:String, password:String, mapID:int, valideTimes:int, canInvite:Boolean, discription:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_ROOM_CREATE);
         pkg.writeUTF(roomName);
         pkg.writeUTF(password);
         pkg.writeInt(mapID);
         pkg.writeInt(valideTimes);
         pkg.writeInt(100);
         pkg.writeBoolean(canInvite);
         pkg.writeUTF(discription);
         pkg.writeBoolean(PlayerManager.Instance.merryActivity);
         this.sendPackage(pkg);
      }
      
      public function sendEnterRoom(id:int, psw:String, sceneIndex:int = 1) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_ROOM_LOGIN);
         pkg.writeInt(id);
         pkg.writeUTF(psw);
         pkg.writeInt(sceneIndex);
         this.sendPackage(pkg);
      }
      
      public function sendExitRoom() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PLAYER_EXIT_MARRY_ROOM);
         this.sendPackage(pkg);
      }
      
      public function sendCurrentState(index:uint) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SCENE_STATE);
         pkg.writeInt(index);
         this.sendPackage(pkg);
      }
      
      public function sendUpdateRoomList(hallType:int, updateType:int, fbId:int = 10000, hardLv:int = 1011) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.ROOMLIST_UPDATE);
         pkg.writeInt(hallType);
         pkg.writeInt(updateType);
         if(hallType == 2 && updateType == -2)
         {
            pkg.writeInt(fbId);
            pkg.writeInt(hardLv);
         }
         this.sendPackage(pkg);
      }
      
      public function sendChurchMove(endX:int, endY:int, path:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         pkg.writeByte(ChurchPackageType.MOVE);
         pkg.writeInt(endX);
         pkg.writeInt(endY);
         pkg.writeUTF(path);
         this.sendPackage(pkg);
      }
      
      public function sendStartWedding(isBind:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         pkg.writeByte(ChurchPackageType.HYMENEAL);
         pkg.writeBoolean(isBind);
         this.sendPackage(pkg);
      }
      
      public function sendChurchContinuation(hours:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         pkg.writeByte(ChurchPackageType.CONTINUATION);
         pkg.writeInt(hours);
         pkg.writeBoolean(PlayerManager.Instance.merryActivity);
         this.sendPackage(pkg);
      }
      
      public function sendChurchInvite(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         pkg.writeByte(ChurchPackageType.INVITE);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendChurchLargess(num:uint) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         pkg.writeByte(ChurchPackageType.LARGESS);
         pkg.writeInt(num);
         this.sendPackage(pkg);
      }
      
      public function refund() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         pkg.writeByte(ChurchPackageType.MARRYROOMSENDGIFT);
         pkg.writeByte(ChurchPackageType.CLIENTCONFIRM);
         this.sendPackage(pkg);
      }
      
      public function requestRefund() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         pkg.writeByte(ChurchPackageType.MARRYROOMSENDGIFT);
         pkg.writeByte(ChurchPackageType.BEGINSENDGIFT);
         this.sendPackage(pkg);
      }
      
      public function sendUseFire(playerID:int, fireTemplateID:int, isBind:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         pkg.writeByte(ChurchPackageType.USEFIRECRACKERS);
         pkg.writeInt(playerID);
         pkg.writeInt(fireTemplateID);
         pkg.writeBoolean(isBind);
         this.sendPackage(pkg);
      }
      
      public function sendChurchKick(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         pkg.writeByte(ChurchPackageType.KICK);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendChurchMovieOver(ID:int, password:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CHURCH_MOVIE_OVER);
         pkg.writeInt(ID);
         pkg.writeUTF(password);
         this.sendPackage(pkg);
      }
      
      public function sendChurchForbid(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         pkg.writeByte(ChurchPackageType.FORBID);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendPosition(x:Number, y:Number) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         pkg.writeByte(ChurchPackageType.POSITION);
         pkg.writeInt(x);
         pkg.writeInt(y);
         this.sendPackage(pkg);
      }
      
      public function sendModifyChurchDiscription(roomName:String, modifyPSW:Boolean, psw:String, discription:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_ROOM_INFO_UPDATE);
         pkg.writeUTF(roomName);
         pkg.writeBoolean(modifyPSW);
         pkg.writeUTF(psw);
         pkg.writeUTF(discription);
         this.sendPackage(pkg);
      }
      
      public function sendSceneChange(sceneIndex:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_SCENE_CHANGE);
         pkg.writeInt(sceneIndex);
         this.sendPackage(pkg);
      }
      
      public function sendGunSalute(userID:int, templeteID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         pkg.writeByte(ChurchPackageType.GUNSALUTE);
         pkg.writeInt(userID);
         pkg.writeInt(templeteID);
         this.sendPackage(pkg);
      }
      
      public function sendRegisterInfo(UserID:int, IsPublishEquip:Boolean, introduction:String = null) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRYINFO_ADD);
         pkg.writeBoolean(IsPublishEquip);
         pkg.writeUTF(introduction);
         pkg.writeInt(UserID);
         this.sendPackage(pkg);
      }
      
      public function sendModifyInfo(IsPublishEquip:Boolean, introduction:String = null) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACHIEVEMENT_UPDATE);
         pkg.writeBoolean(IsPublishEquip);
         pkg.writeUTF(introduction);
         this.sendPackage(pkg);
      }
      
      public function sendForMarryInfo(MarryInfoID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MARRYINFO_GET);
         pkg.writeInt(MarryInfoID);
         this.sendPackage(pkg);
      }
      
      public function sendGetLinkGoodsInfo(type:int, key:String, templeteIDorItemID:String = "") : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LINKREQUEST_GOODS);
         pkg.writeInt(type);
         pkg.writeUTF(key);
         pkg.writeUTF(templeteIDorItemID);
         this.sendPackage(pkg);
      }
      
      public function sendGetTropToBag(place:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_TAKE_TEMP);
         pkg.writeInt(place);
         this.sendPackage(pkg);
      }
      
      public function createUserGuide(roomType:int = 10) : void
      {
         var randomPass:String = String(Math.random());
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.GAME_ROOM_CREATE);
         pkg.writeByte(roomType);
         pkg.writeByte(3);
         pkg.writeUTF("");
         pkg.writeUTF(randomPass);
         this.sendPackage(pkg);
      }
      
      public function enterUserGuide(pveId:int, roomType:int = 10) : void
      {
         var randomPass:String = String(Math.random());
         var secType:int = PlayerManager.Instance.Self.Grade < 5 ? 4 : 3;
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.GAME_ROOM_SETUP_CHANGE);
         pkg.writeInt(pveId);
         pkg.writeByte(roomType);
         pkg.writeBoolean(false);
         pkg.writeUTF(randomPass);
         pkg.writeUTF("");
         pkg.writeByte(secType);
         pkg.writeByte(0);
         pkg.writeInt(0);
         pkg.writeBoolean(false);
         pkg.writeInt(0);
         this.sendPackage(pkg);
      }
      
      public function userGuideStart() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.GAME_START);
         this.sendPackage(pkg);
      }
      
      public function sendSaveDB() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SAVE_DB);
         this.sendPackage(pkg);
      }
      
      public function createMonster() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         pkg.writeInt(0);
         this.sendPackage(pkg);
      }
      
      public function deleteMonster() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         pkg.writeInt(1);
         this.sendPackage(pkg);
      }
      
      public function sendHotSpringEnter() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_ENTER);
         this.sendPackage(pkg);
      }
      
      public function sendHotSpringRoomCreate(roomVo:*) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_CREATE);
         pkg.writeUTF(roomVo.roomName);
         pkg.writeUTF(roomVo.roomPassword);
         pkg.writeUTF(roomVo.roomIntroduction);
         pkg.writeInt(roomVo.maxCount);
         this.sendPackage(pkg);
      }
      
      public function sendHotSpringRoomEdit(roomVo:*) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         pkg.writeByte(HotSpringPackageType.HOTSPRING_ROOM_EDIT);
         pkg.writeUTF(roomVo.roomName);
         pkg.writeUTF(roomVo.roomPassword);
         pkg.writeUTF(roomVo.roomIntroduction);
         this.sendPackage(pkg);
      }
      
      public function sendHotSpringRoomQuickEnter() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_QUICK_ENTER);
         this.sendPackage(pkg);
      }
      
      public function sendHotSpringRoomEnterConfirm(roomID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_ENTER_CONFIRM);
         pkg.writeInt(roomID);
         this.sendPackage(pkg);
      }
      
      public function sendHotSpringRoomEnter(roomID:int, roomPassword:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_ENTER);
         pkg.writeInt(roomID);
         pkg.writeUTF(roomPassword);
         this.sendPackage(pkg);
      }
      
      public function sendHotSpringRoomEnterView(state:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_ENTER_VIEW);
         pkg.writeInt(state);
         this.sendPackage(pkg);
      }
      
      public function sendHotSpringRoomPlayerRemove() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_PLAYER_REMOVE);
         this.sendPackage(pkg);
      }
      
      public function sendHotSpringRoomPlayerTargetPoint(playerVO:*) : void
      {
         var i:uint = 0;
         var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         pkg.writeByte(HotSpringPackageType.TARGET_POINT);
         var souArr:Array = playerVO.walkPath.concat();
         for(var arr:Array = []; i < souArr.length; )
         {
            arr.push(int(souArr[i].x),int(souArr[i].y));
            i++;
         }
         var pathStr:String = arr.toString();
         pkg.writeUTF(pathStr);
         pkg.writeInt(playerVO.playerInfo.ID);
         pkg.writeInt(playerVO.currentWalkStartPoint.x);
         pkg.writeInt(playerVO.currentWalkStartPoint.y);
         pkg.writeInt(1);
         pkg.writeInt(playerVO.playerDirection);
         this.sendPackage(pkg);
      }
      
      public function sendHotSpringRoomRenewalFee(roomID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         pkg.writeByte(HotSpringPackageType.HOTSPRING_ROOM_RENEWAL_FEE);
         pkg.writeInt(roomID);
         this.sendPackage(pkg);
      }
      
      public function sendHotSpringRoomInvite(playerID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         pkg.writeByte(HotSpringPackageType.HOTSPRING_ROOM_INVITE);
         pkg.writeInt(playerID);
         this.sendPackage(pkg);
      }
      
      public function sendHotSpringRoomAdminRemovePlayer(playerID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         pkg.writeByte(HotSpringPackageType.HOTSPRING_ROOM_ADMIN_REMOVE_PLAYER);
         pkg.writeInt(playerID);
         this.sendPackage(pkg);
      }
      
      public function sendHotSpringRoomPlayerContinue(isContinue:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         pkg.writeByte(HotSpringPackageType.HOTSPRING_ROOM_PLAYER_CONTINUE);
         pkg.writeBoolean(isContinue);
         this.sendPackage(pkg);
      }
      
      public function sendGetTimeBox(boxType:int, boxNumber:int, lession:int = -1, level:int = -1) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GET_TIME_BOX);
         pkg.writeInt(boxType);
         pkg.writeInt(boxNumber);
         pkg.writeInt(lession);
         pkg.writeInt(level);
         this.sendPackage(pkg);
      }
      
      public function sendAchievementFinish(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACHIEVEMENT_FINISH);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendReworkRank(rank:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.USER_CHANGE_RANK);
         pkg.writeUTF(rank);
         this.sendPackage(pkg);
      }
      
      public function sendLookupEffort(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LOOKUP_EFFORT);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendBeginFightNpc() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FIGHT_NPC);
         this.sendPackage(pkg);
      }
      
      public function sendRequestUpdate() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.REQUEST_UPDATE);
         this.sendPackage(pkg);
      }
      
      public function sendQuestionReply(questionReply:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.QUESTION_REPLY);
         pkg.writeInt(questionReply);
         this.sendPackage(pkg);
      }
      
      public function sendOpenVip(name:String, days:int, bool:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.VIP_RENEWAL);
         pkg.writeUTF(name);
         pkg.writeInt(days);
         pkg.writeBoolean(bool);
         pkg.writeBoolean(PlayerManager.Instance.vipActivity);
         this.sendPackage(pkg);
      }
      
      public function sendAcademyRegister(UserID:int, IsPublishEquip:Boolean, introduction:String = null, isAmend:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         pkg.writeByte(AcademyPackageType.ACADEMY_REGISTER);
         pkg.writeInt(UserID);
         pkg.writeBoolean(IsPublishEquip);
         pkg.writeUTF(introduction);
         pkg.writeBoolean(isAmend);
         this.sendPackage(pkg);
      }
      
      public function sendAcademyRemoveRegister() : void
      {
         var pkg:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         pkg.writeByte(AcademyPackageType.ACADEMY_REMOVE);
         this.sendPackage(pkg);
      }
      
      public function sendAcademyApprentice(id:int, introduction:String) : void
      {
         var pkg:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         pkg.writeByte(AcademyPackageType.ACADEMY_FOR_APPRENTICE);
         pkg.writeInt(id);
         pkg.writeUTF(introduction);
         this.sendPackage(pkg);
      }
      
      public function sendAcademyMaster(id:int, introduction:String) : void
      {
         var pkg:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         pkg.writeByte(AcademyPackageType.ACADEMY_FOR_MASTER);
         pkg.writeInt(id);
         pkg.writeUTF(introduction);
         this.sendPackage(pkg);
      }
      
      public function sendAcademyMasterConfirm(value:Boolean, id:int) : void
      {
         var pkg:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         if(value)
         {
            pkg.writeByte(AcademyPackageType.MASTER_CONFIRM);
         }
         else
         {
            pkg.writeByte(AcademyPackageType.MASTER_REFUSE);
         }
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendAcademyApprenticeConfirm(value:Boolean, id:int) : void
      {
         var pkg:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         if(value)
         {
            pkg.writeByte(AcademyPackageType.APPRENTICE_CONFIRM);
         }
         else
         {
            pkg.writeByte(AcademyPackageType.APPRENTICE_REFUSE);
         }
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendAcademyFireMaster(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         pkg.writeByte(AcademyPackageType.FIRE_MASTER);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendAcademyFireApprentice(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         pkg.writeByte(AcademyPackageType.FIRE_APPRENTICE);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendUseLog(type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.USE_LOG);
         pkg.writeInt(type);
         this.sendPackage(pkg);
      }
      
      public function sendBuyGift(nickName:String, goodsId:int, count:int, type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.USER_SEND_GIFTS);
         pkg.writeUTF(nickName);
         pkg.writeInt(goodsId);
         pkg.writeInt(count);
         pkg.writeInt(type);
         this.sendPackage(pkg);
      }
      
      public function sendReloadGift() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.USER_RELOAD_GIFT);
         this.sendPackage(pkg);
      }
      
      public function sendSnsMsg($typeId:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SNS_MSG_RECEIVE);
         pkg.writeInt($typeId);
         this.sendPackage(pkg);
      }
      
      public function getPlayerCardInfo(playerId:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GET_PLAYER_CARD);
         pkg.writeInt(playerId);
         this.sendPackage(pkg);
      }
      
      public function sendMoveCards(from:int, to:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         pkg.writeInt(0);
         pkg.writeInt(from);
         pkg.writeInt(to);
         this.sendPackage(pkg);
      }
      
      public function sendOpenViceCard(place:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         pkg.writeInt(1);
         pkg.writeInt(place);
         this.sendPackage(pkg);
      }
      
      public function sendOpenCardBox(id:int, num:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         pkg.writeInt(1);
         pkg.writeInt(id);
         pkg.writeInt(num);
         this.sendPackage(pkg);
      }
      
      public function sendOpenRandomBox(id:int, num:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         pkg.writeInt(4);
         pkg.writeInt(id);
         pkg.writeInt(num);
         this.sendPackage(pkg);
      }
      
      public function sendUpGradeCard(place:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         pkg.writeInt(2);
         pkg.writeInt(place);
         this.sendPackage(pkg);
      }
      
      public function sendUpdateSLOT(place:int, num:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CARDS_SLOT);
         pkg.writeInt(0);
         pkg.writeInt(place);
         pkg.writeInt(num);
         this.sendPackage(pkg);
      }
      
      public function sendResetCardSoul(bool:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CARDS_SLOT);
         pkg.writeInt(1);
         pkg.writeBoolean(bool);
         this.sendPackage(pkg);
      }
      
      public function sendCardReset(place:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CARD_RESET);
         pkg.writeInt(0);
         pkg.writeInt(place);
         this.sendPackage(pkg);
      }
      
      public function sendReplaceCardProp(place:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CARD_RESET);
         pkg.writeInt(1);
         pkg.writeInt(place);
         this.sendPackage(pkg);
      }
      
      public function sendSortCards(data:Vector.<int>) : void
      {
         var old:int = 0;
         var now:int = 0;
         var pkg:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         pkg.writeInt(2);
         var len:int = int(data.length);
         pkg.writeInt(len);
         for(var i:int = 0; i < len; i++)
         {
            old = data[i];
            now = i + CardModel.EQUIP_CELLS_SUM;
            pkg.writeInt(old);
            pkg.writeInt(now);
         }
         this.sendPackage(pkg);
      }
      
      public function sendFirstGetCards() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         pkg.writeInt(3);
         this.sendPackage(pkg);
      }
      
      public function sendGetCardSoul() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         pkg.writeInt(5);
         this.sendPackage(pkg);
      }
      
      public function sendFace(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SCENE_FACE);
         pkg.writeInt(id);
         pkg.writeInt(0);
         this.sendPackage(pkg);
      }
      
      public function sendOpition(value:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.OPTION_UPDATE);
         pkg.writeInt(value);
         this.sendPackage(pkg);
      }
      
      public function sendConsortionMail(topic:String, content:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTION_MAIL);
         pkg.writeUTF(topic);
         pkg.writeUTF(content);
         this.sendPackage(pkg);
      }
      
      public function sendConsortionPoll(candidateID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.POLL_CANDIDATE);
         pkg.writeInt(candidateID);
         this.sendPackage(pkg);
      }
      
      public function sendConsortionSkill(isopen:Boolean, id:int, vaildDay:int, type:int = 1) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.SKILL_SOCKET);
         pkg.writeBoolean(isopen);
         pkg.writeInt(id);
         pkg.writeInt(vaildDay);
         pkg.writeInt(type);
         this.sendPackage(pkg);
      }
      
      public function sendOns() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.IM_CMD);
         pkg.writeByte(IMPackageType.ONS_EQUIP);
         this.sendPackage(pkg);
      }
      
      public function sendWithBrithday(vec:Vector.<FriendListPlayer>) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FRIEND_BRITHDAY);
         pkg.writeInt(vec.length);
         for(var i:int = 0; i < vec.length; i++)
         {
            pkg.writeInt(vec[i].ID);
            pkg.writeUTF(vec[i].NickName);
            pkg.writeDate(vec[i].BirthdayDate);
         }
         this.sendPackage(pkg);
      }
      
      public function sendChangeDesignation(boo:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.USER_RANK);
         pkg.writeBoolean(boo);
         this.sendPackage(pkg);
      }
      
      public function sendDailyRecord() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.DAILYRECORD);
         this.sendPackage(pkg);
      }
      
      public function sendCollectInfoValidate(type:int, validate:String, id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.COLLECTINFO);
         pkg.writeByte(type);
         pkg.writeUTF(validate);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendGoodsExchange(list:Vector.<SendGoodsExchangeInfo>, ActiveID:int, count:int, awardIndex:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GOODS_EXCHANGE);
         pkg.writeInt(ActiveID);
         pkg.writeInt(count);
         pkg.writeInt(list.length);
         for(var i:int = 0; i < list.length; i++)
         {
            pkg.writeInt(list[i].id);
            pkg.writeInt(list[i].place);
            pkg.writeInt(list[i].bagType);
         }
         pkg.writeInt(awardIndex);
         this.sendPackage(pkg);
      }
      
      public function sendTexp(type:int, templateID:int, count:int, place:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TEXP);
         pkg.writeInt(type);
         pkg.writeInt(templateID);
         pkg.writeInt(count);
         pkg.writeInt(place);
         this.sendPackage(pkg);
      }
      
      public function sendCustomFriends(type:int, id:int, name:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.IM_CMD);
         pkg.writeByte(IMPackageType.ADD_CUSTOM_FRIENDS);
         pkg.writeByte(type);
         pkg.writeInt(id);
         pkg.writeUTF(name);
         this.sendPackage(pkg);
      }
      
      public function sendOneOnOneTalk(id:int, content:String, isAutoReply:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.IM_CMD);
         pkg.writeByte(IMPackageType.ONE_ON_ONE_TALK);
         pkg.writeInt(id);
         pkg.writeUTF(content);
         pkg.writeBoolean(isAutoReply);
         this.sendPackage(pkg);
      }
      
      public function sendUserLuckyNum(num:int, hasChoose:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.USER_LUCKYNUM);
         pkg.writeBoolean(hasChoose);
         pkg.writeInt(num);
         this.sendPackage(pkg);
      }
      
      public function sendPicc(id:int, price:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PICC);
         pkg.writeInt(id);
         pkg.writeInt(price);
         this.sendPackage(pkg);
      }
      
      public function sendBuyBadge(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.BUY_BADGE);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendGetEliteGameState() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ELITEGAME);
         pkg.writeByte(EliteGamePackageType.ELITE_MATCH_TYPE);
         this.sendPackage(pkg);
      }
      
      public function sendGetSelfRankSroce() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ELITEGAME);
         pkg.writeByte(EliteGamePackageType.ELITE_MATCH_PLAYER_RANK);
         this.sendPackage(pkg);
      }
      
      public function sendGetPaarungDetail(type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ELITEGAME);
         pkg.writeByte(EliteGamePackageType.ELITE_MATCH_RANK_DETAIL);
         pkg.writeInt(type);
         this.sendPackage(pkg);
      }
      
      public function sendEliteGameStart() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ELITEGAME);
         pkg.writeByte(EliteGamePackageType.ELITE_MATCH_RANK_START);
         this.sendPackage(pkg);
      }
      
      public function sendStartTurn_LeftGun() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LEFT_GUN_ROULETTE_SOCKET);
         pkg.writeInt(1);
         this.sendPackage(pkg);
      }
      
      public function sendEndTurn_LeftGun() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LEFT_GUN_ROULETTE_COMPLETTE);
         pkg.writeInt(1);
         this.sendPackage(pkg);
      }
      
      public function sendWishBeadEquip(equipPlace:int, equipBagType:int, equipId:int, beadPlace:int, beadBagType:int, beadId:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WISHBEADEQUIP);
         pkg.writeInt(equipPlace);
         pkg.writeInt(equipBagType);
         pkg.writeInt(equipId);
         pkg.writeInt(beadPlace);
         pkg.writeInt(beadBagType);
         pkg.writeInt(beadId);
         this.sendPackage(pkg);
      }
      
      public function sendPetMove(fromPlace:int, toPlace:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PET);
         pkg.writeByte(CrazyTankPackageType.MOVE_PETBAG);
         pkg.writeInt(fromPlace);
         pkg.writeInt(toPlace);
         this.sendPackage(pkg);
      }
      
      public function sendPetFightUnFight(place:int, isFight:Boolean = true) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PET);
         pkg.writeByte(CrazyTankPackageType.FIGHT_PET);
         pkg.writeInt(place);
         pkg.writeBoolean(isFight);
         this.sendPackage(pkg);
      }
      
      public function sendPetFeed(foodPlace:int, foodBag:int, petPlace:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PET);
         pkg.writeByte(CrazyTankPackageType.FEED_PET);
         pkg.writeInt(foodPlace);
         pkg.writeInt(foodBag);
         pkg.writeInt(petPlace);
         this.sendPackage(pkg);
      }
      
      public function sendEquipPetSkill(petPlace:int, skillID:int, index:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PET);
         pkg.writeByte(CrazyTankPackageType.EQUIP_PET_SKILL);
         pkg.writeInt(petPlace);
         pkg.writeInt(skillID);
         pkg.writeInt(index);
         this.sendPackage(pkg);
      }
      
      public function sendPetRename(place:int, name:String, bool:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PET);
         pkg.writeByte(CrazyTankPackageType.RENAME_PET);
         pkg.writeInt(place);
         pkg.writeUTF(name);
         pkg.writeBoolean(bool);
         this.sendPackage(pkg);
      }
      
      public function sendReleasePet(place:int, isPay:Boolean = false, isBind:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PET);
         pkg.writeByte(CrazyTankPackageType.RELEASE_PET);
         pkg.writeInt(place);
         pkg.writeBoolean(isPay);
         pkg.writeBoolean(isBind);
         this.sendPackage(pkg);
      }
      
      public function sendAdoptPet(index:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PET);
         pkg.writeByte(CrazyTankPackageType.ADOPT_PET);
         pkg.writeInt(index);
         this.sendPackage(pkg);
      }
      
      public function sendRefreshPet(isPay:Boolean = false, bool:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PET);
         pkg.writeByte(CrazyTankPackageType.REFRESH_PET);
         pkg.writeBoolean(isPay);
         pkg.writeBoolean(bool);
         this.sendPackage(pkg);
      }
      
      public function sendUpdatePetInfo(plyaerID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PET);
         pkg.writeByte(CrazyTankPackageType.UPDATE_PET);
         pkg.writeInt(plyaerID);
         this.sendPackage(pkg);
      }
      
      public function sendPaySkill(placeID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PET);
         pkg.writeByte(CrazyTankPackageType.PAY_SKILL);
         pkg.writeInt(placeID);
         this.sendPackage(pkg);
      }
      
      public function sendAddPet(placeID:int, bagType:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PET);
         pkg.writeByte(CrazyTankPackageType.ADD_PET);
         pkg.writeInt(placeID);
         pkg.writeInt(bagType);
         this.sendPackage(pkg);
      }
      
      public function sendNewTitleCard(placeID:int, bagType:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.NEWTITLE_CARD);
         pkg.writeByte(bagType);
         pkg.writeInt(placeID);
         this.sendPackage(pkg);
      }
      
      public function enterFarm(useid:int) : void
      {
         var p:PackageOut = new PackageOut(ePackageType.FARM);
         p.writeByte(FarmPackageType.ENTER_FARM);
         p.writeInt(useid);
         this.sendPackage(p);
      }
      
      public function seeding(fieldID:int, seedsId:int) : void
      {
         var p:PackageOut = new PackageOut(ePackageType.FARM);
         p.writeByte(FarmPackageType.GROW_FIELD);
         p.writeByte(13);
         p.writeInt(seedsId);
         p.writeInt(fieldID);
         this.sendPackage(p);
      }
      
      public function arrange(useID:int) : void
      {
         var p:PackageOut = new PackageOut(ePackageType.TREASURE_IN);
         p.writeInt(TreasurePackageType.ARRANGE_FRIEND_FARM);
         p.writeInt(useID);
         this.sendPackage(p);
      }
      
      public function enterTreasure() : void
      {
         var p:PackageOut = new PackageOut(ePackageType.TREASURE_IN);
         p.writeInt(TreasurePackageType.IN_TREASURE);
         this.sendPackage(p);
      }
      
      public function startTreasure() : void
      {
         var p:PackageOut = new PackageOut(ePackageType.TREASURE_IN);
         p.writeInt(TreasurePackageType.START_GAME);
         this.sendPackage(p);
      }
      
      public function endTreasure() : void
      {
         var p:PackageOut = new PackageOut(ePackageType.TREASURE_IN);
         p.writeInt(TreasurePackageType.END_TREASURE);
         this.sendPackage(p);
      }
      
      public function doTreasure(pos:int) : void
      {
         var p:PackageOut = new PackageOut(ePackageType.TREASURE_IN);
         p.writeInt(TreasurePackageType.DIG);
         p.writeInt(pos);
         this.sendPackage(p);
      }
      
      public function sendCompose(foodID:int, count:int = 1) : void
      {
         var p:PackageOut = new PackageOut(ePackageType.FARM);
         p.writeByte(FarmPackageType.COMPOSE_FOOD);
         p.writeInt(foodID);
         p.writeInt(count);
         this.sendPackage(p);
      }
      
      public function doMature(type:int, fieldID:int, manureId:int) : void
      {
         var p:PackageOut = new PackageOut(ePackageType.FARM);
         p.writeByte(FarmPackageType.ACCELERATE_FIELD);
         p.writeByte(13);
         p.writeInt(type);
         p.writeInt(manureId);
         p.writeInt(fieldID);
         this.sendPackage(p);
      }
      
      public function toGather(userid:int, fieldid:int) : void
      {
         var p:PackageOut = new PackageOut(ePackageType.FARM);
         p.writeByte(FarmPackageType.GAIN_FIELD);
         p.writeInt(userid);
         p.writeInt(fieldid);
         this.sendPackage(p);
      }
      
      public function toSpread(idArr:Array, payDate:int, bool:Boolean) : void
      {
         var id:int = 0;
         if(!idArr || idArr.length == 0)
         {
            return;
         }
         var p:PackageOut = new PackageOut(ePackageType.FARM);
         p.writeByte(FarmPackageType.PAY_FIELD);
         p.writeInt(idArr.length);
         for each(id in idArr)
         {
            p.writeInt(id);
         }
         p.writeInt(payDate);
         p.writeBoolean(bool);
         this.sendPackage(p);
      }
      
      public function sendWish() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.WISHOFDD);
         this.sendPackage(pkg);
      }
      
      public function sendChangeSex(bagType:int, place:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.USE_CHANGE_SEX);
         pkg.writeByte(bagType);
         pkg.writeInt(place);
         this.sendPackage(pkg);
      }
      
      public function toFarmHelper(temp:Array, isAuto:Boolean) : void
      {
         var obj:Object = null;
         var p:PackageOut = new PackageOut(ePackageType.FARM);
         p.writeByte(FarmPackageType.HELPER_SWITCH_FIELD);
         p.writeInt(temp.length);
         for(var i:int = 0; i < temp.length; i++)
         {
            obj = temp[i];
            p.writeInt(obj.currentfindIndex);
            p.writeInt(obj.currentSeedText);
            p.writeInt(obj.currentSeedNum);
            p.writeInt(obj.currentFertilizerText);
            p.writeInt(obj.autoFertilizerNum);
            p.writeBoolean(isAuto);
         }
         this.sendPackage(p);
      }
      
      public function sendBeginHelper(array:Array) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FARM);
         pkg.writeByte(FarmPackageType.HELPER_SWITCH_FIELD);
         pkg.writeBoolean(array[0]);
         if(Boolean(array[0]))
         {
            pkg.writeInt(array[1]);
            pkg.writeInt(array[2]);
            pkg.writeInt(array[3]);
            pkg.writeInt(array[4]);
            pkg.writeInt(array[5]);
            pkg.writeInt(array[6]);
            pkg.writeBoolean(array[7]);
         }
         this.sendPackage(pkg);
      }
      
      public function toKillCrop(fieldId:int) : void
      {
         var p:PackageOut = new PackageOut(ePackageType.FARM);
         p.writeByte(FarmPackageType.KILLCROP_FIELD);
         p.writeInt(fieldId);
         this.sendPackage(p);
      }
      
      public function toHelperRenewMoney(hour:int, bool:Boolean) : void
      {
         var p:PackageOut = new PackageOut(ePackageType.FARM);
         p.writeByte(FarmPackageType.HELPER_PAY_FIELD);
         p.writeInt(hour);
         p.writeBoolean(bool);
         this.sendPackage(p);
      }
      
      public function exitFarm(playerID:int) : void
      {
         var p:PackageOut = new PackageOut(ePackageType.FARM);
         p.writeByte(FarmPackageType.EXIT_FARM);
         p.writeInt(playerID);
         this.sendPackage(p);
      }
      
      public function fastForwardGrop(isBind:Boolean, isAll:Boolean, index:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FARM);
         pkg.writeByte(FarmPackageType.FRAM_GROP_FASTFORWARD);
         pkg.writeBoolean(isBind);
         pkg.writeBoolean(isAll);
         pkg.writeInt(index);
         this.sendPackage(pkg);
      }
      
      public function giftPacks(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FARM);
         pkg.writeByte(FarmPackageType.FARM_GIFTPACKS);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function getFarmPoultryLevel(userId:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FARM);
         pkg.writeByte(FarmPackageType.FARM_POULTYRLEVEL);
         pkg.writeInt(userId);
         this.sendPackage(pkg);
      }
      
      public function initFarmTree() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FARM);
         pkg.writeByte(FarmPackageType.FARM_UPGRADEINITTREE);
         this.sendPackage(pkg);
      }
      
      public function callFarmPoultry(treeLevel:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FARM);
         pkg.writeByte(FarmPackageType.FARM_CALLPOULTYR);
         pkg.writeInt(treeLevel);
         this.sendPackage(pkg);
      }
      
      public function wakeFarmPoultry(id:uint) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FARM);
         pkg.writeByte(FarmPackageType.FARM_POULTYWAKE);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function feedFarmPoultry(id:uint) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FARM);
         pkg.writeByte(FarmPackageType.FARM_POULTYRFEED);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function farmCondenser(num:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FARM);
         pkg.writeByte(FarmPackageType.FARM_CONDENSER);
         pkg.writeInt(num);
         this.sendPackage(pkg);
      }
      
      public function farmWater(num:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FARM);
         pkg.writeByte(FarmPackageType.FARM_WATER);
         pkg.writeInt(num);
         this.sendPackage(pkg);
      }
      
      public function getPlayerPropertyAddition() : void
      {
         var p:PackageOut = new PackageOut(ePackageType.UPDATE_PLAYER_PROPERTY);
         this.sendPackage(p);
      }
      
      public function enterWorldBossRoom() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         pkg.writeByte(WorldBossGamePackageType.ENTER_WORLDBOSSROOM);
         this.sendPackage(pkg);
      }
      
      public function openOrCloseWorldBossHelper(data:WorldBossHelperTypeData) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         pkg.writeByte(WorldBossGamePackageType.ASSISTANT);
         pkg.writeByte(data.requestType);
         if(data.requestType == 2)
         {
            pkg.writeBoolean(data.isOpen);
            pkg.writeInt(data.buffNum);
            pkg.writeInt(data.type);
            pkg.writeInt(data.openType);
         }
         this.sendPackage(pkg);
      }
      
      public function quitWorldBossHelperView() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         pkg.writeByte(WorldBossGamePackageType.ENTRYSCENES);
         pkg.writeBoolean(false);
         this.sendPackage(pkg);
      }
      
      public function sendAddPlayer(position:Point) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         pkg.writeByte(WorldBossGamePackageType.ADDPLAYERS);
         pkg.writeInt(position.x);
         pkg.writeInt(position.y);
         this.sendPackage(pkg);
      }
      
      public function sendAddAllWorldBossPlayer() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         pkg.writeByte(WorldBossPackageType.WORLDBOSS_ALLPLAYERINFO);
         this.sendPackage(pkg);
      }
      
      public function sendWorldBossRoomMove(endX:int, endY:int, path:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         pkg.writeByte(WorldBossGamePackageType.MOVE);
         pkg.writeInt(endX);
         pkg.writeInt(endY);
         pkg.writeUTF(path);
         this.sendPackage(pkg);
      }
      
      public function sendWorldBossRoomStauts(status:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         pkg.writeByte(WorldBossGamePackageType.STAUTS);
         pkg.writeByte(status);
         this.sendPackage(pkg);
      }
      
      public function sendLeaveBossRoom() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         pkg.writeByte(WorldBossGamePackageType.LEAVE_ROOM);
         this.sendPackage(pkg);
      }
      
      public function sendBuyWorldBossBuff(arr:Array) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         pkg.writeByte(WorldBossGamePackageType.BUFF_BUY);
         pkg.writeInt(arr.length);
         for(var i:int = 0; i < arr.length; i++)
         {
            pkg.writeInt(arr[i]);
         }
         this.sendPackage(pkg);
      }
      
      public function gotoCardLottery() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GOTO_CARD_LOTTERY);
         this.sendPackage(pkg);
      }
      
      public function sendCardLotteryIds(ids:Array) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CARD_LOTTERY);
         pkg.writeInt(ids.length);
         for(var i:int = 0; i < ids.length; i++)
         {
            pkg.writeInt(ids[i]);
         }
         this.sendPackage(pkg);
      }
      
      public function sendNewBuyWorldBossBuff(type:int, count:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         pkg.writeByte(WorldBossGamePackageType.BUFF_BUY);
         pkg.writeInt(1);
         pkg.writeInt(type);
         pkg.writeInt(count);
         this.sendPackage(pkg);
      }
      
      public function sendLuckLottery() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LUCK_LOTTERY);
         this.sendPackage(pkg);
      }
      
      public function sendRevertPet(petPos:int, bool:Boolean) : void
      {
         var p:PackageOut = new PackageOut(ePackageType.PET);
         p.writeByte(CrazyTankPackageType.REVER_PET);
         p.writeInt(petPos);
         p.writeBoolean(bool);
         this.sendPackage(p);
      }
      
      public function requestForLuckStone() : void
      {
         var p:PackageOut = new PackageOut(ePackageType.LUCKSTONE_CONFIG);
         this.sendPackage(p);
      }
      
      public function sendOpenOneTotem(isActPro:Boolean, isBind:Boolean) : void
      {
         var p:PackageOut = new PackageOut(ePackageType.TOTEM);
         p.writeBoolean(isActPro);
         p.writeBoolean(isBind);
         this.sendPackage(p);
      }
      
      public function sendChickenBoxUseEagleEye(item:NewChickenBoxItem) : void
      {
         var p:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         p.writeInt(NewChickenBoxPackageType.USEEAGLEEYE);
         p.writeInt(item.position);
         this.sendPackage(p);
      }
      
      public function sendChickenBoxTakeOverCard(item:NewChickenBoxItem) : void
      {
         var p:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         p.writeInt(NewChickenBoxPackageType.TAKEOVERCARD);
         p.writeInt(item.info.Position);
         this.sendPackage(p);
      }
      
      public function sendOverShowItems() : void
      {
         var p:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         p.writeInt(NewChickenBoxPackageType.AllITEMSHOW);
         this.sendPackage(p);
      }
      
      public function sendFlushNewChickenBox() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         pkg.writeInt(NewChickenBoxPackageType.FLUSHCHICKENVIEW);
         this.sendPackage(pkg);
      }
      
      public function sendClickStartBntNewChickenBox() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         pkg.writeInt(NewChickenBoxPackageType.CLICKSTARTBNT);
         this.sendPackage(pkg);
      }
      
      public function sendNewChickenBox() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         pkg.writeInt(NewChickenBoxPackageType.ENTERCHICKENVIEW);
         this.sendPackage(pkg);
      }
      
      public function labyrinthRequestUpdate() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         pkg.writeInt(LabyrinthPackageType.REQUEST_UPDATE);
         this.sendPackage(pkg);
      }
      
      public function labyrinthCleanOut() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         pkg.writeInt(LabyrinthPackageType.CLEAN_OUT);
         this.sendPackage(pkg);
      }
      
      public function labyrinthSpeededUpCleanOut(bool:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         pkg.writeInt(LabyrinthPackageType.SPEEDED_UP_CLEAN_OUT);
         pkg.writeBoolean(bool);
         this.sendPackage(pkg);
      }
      
      public function labyrinthStopCleanOut() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         pkg.writeInt(LabyrinthPackageType.STOP_CLEAN_OUT);
         this.sendPackage(pkg);
      }
      
      public function figSpiritUpGrade(obj:GemstnoeSendInfo) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FIGHT_SPIRIT);
         pkg.writeByte(FightSpiritPackageType.FIGHT_SPIRIT_LEVELUP);
         pkg.writeInt(obj.autoBuyId);
         pkg.writeInt(obj.goodsId);
         pkg.writeInt(obj.type);
         pkg.writeInt(obj.templeteId);
         pkg.writeInt(obj.fightSpiritId);
         pkg.writeInt(obj.equipPlayce);
         pkg.writeInt(obj.place);
         pkg.writeInt(obj.count);
         this.sendPackage(pkg);
      }
      
      public function fightSpiritRequest() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FIGHT_SPIRIT);
         pkg.writeByte(FightSpiritPackageType.FIGHT_SPIRIT_INIT);
         this.sendPackage(pkg);
      }
      
      public function labyrinthCleanOutTimerComplete() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         pkg.writeInt(LabyrinthPackageType.CLEAN_OUT_COMPLETE);
         this.sendPackage(pkg);
      }
      
      public function labyrinthDouble(value:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         pkg.writeInt(LabyrinthPackageType.DOUBLE_REWARD);
         pkg.writeBoolean(value);
         this.sendPackage(pkg);
      }
      
      public function labyrinthReset() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         pkg.writeInt(LabyrinthPackageType.RESET_LABYRINTH);
         this.sendPackage(pkg);
      }
      
      public function labyrinthTryAgain(value:Boolean, bool:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         pkg.writeInt(LabyrinthPackageType.TRY_AGAIN);
         pkg.writeBoolean(value);
         pkg.writeBoolean(bool);
         this.sendPackage(pkg);
      }
      
      public function getspree(value:Object) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.RECHARGE);
         pkg.writeInt(RechargePackageType.REGET_SPREE);
         pkg.writeInt(value.rewardId);
         pkg.writeInt(value.type);
         pkg.writeInt(value.regetType);
         pkg.writeInt(value.time);
         this.sendPackage(pkg);
      }
      
      public function sendHonorUp(type:int, bool:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HONOR_UP_COUNT);
         pkg.writeByte(type);
         pkg.writeBoolean(bool);
         this.sendPackage(pkg);
      }
      
      public function sendBuyPetExpItem(bool:Boolean) : void
      {
         var p:PackageOut = new PackageOut(ePackageType.PET);
         p.writeByte(FarmPackageType.BUY_PET_EXP_ITEM);
         p.writeBoolean(bool);
         this.sendPackage(p);
      }
      
      public function sendOpenKingBless(type:int, playerId:int, msg:String, bool:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.KING_BLESS_MAIN);
         pkg.writeByte(type);
         pkg.writeInt(playerId);
         pkg.writeUTF(msg);
         pkg.writeBoolean(bool);
         this.sendPackage(pkg);
      }
      
      public function sendUseItemKingBless(place:int, bagType:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.KING_BLESS_USE_ITEM);
         pkg.writeInt(place);
         pkg.writeInt(bagType);
         this.sendPackage(pkg);
      }
      
      public function sendTrusteeshipStart(questId:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TRUSTEESHIP);
         pkg.writeByte(TrusteeshipPackageType.START);
         pkg.writeInt(questId);
         this.sendPackage(pkg);
      }
      
      public function sendTrusteeshipCancel(questId:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TRUSTEESHIP);
         pkg.writeByte(TrusteeshipPackageType.CANCEL);
         pkg.writeInt(questId);
         this.sendPackage(pkg);
      }
      
      public function sendTrusteeshipSpeedUp(questId:int, bool:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TRUSTEESHIP);
         pkg.writeByte(TrusteeshipPackageType.SPEED_UP);
         pkg.writeInt(questId);
         pkg.writeBoolean(bool);
         this.sendPackage(pkg);
      }
      
      public function sendTrusteeshipBuySpirit(bool:Boolean = true) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TRUSTEESHIP);
         pkg.writeByte(TrusteeshipPackageType.BUY_SPIRIT);
         pkg.writeBoolean(bool);
         this.sendPackage(pkg);
      }
      
      public function battleGroundUpdata(type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.BATTLE_GROUND);
         pkg.writeByte(BattleGoundPackageType.UPDATE_VALUE_REQ);
         pkg.writeByte(type);
         this.sendPackage(pkg);
      }
      
      public function battleGroundPlayerUpdata() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.BATTLE_GROUND);
         pkg.writeByte(BattleGoundPackageType.UPDATE_PLAYER_DATA);
         this.sendPackage(pkg);
      }
      
      public function sendTrusteeshipUseSpiritItem(place:int, bagType:int, num:int = 1) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TRUSTEESHIP);
         pkg.writeByte(TrusteeshipPackageType.USE_SPIRIT_ITME);
         pkg.writeInt(place);
         pkg.writeInt(bagType);
         pkg.writeInt(num);
         this.sendPackage(pkg);
      }
      
      public function sendDeskTopLogin(type:int = 0) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LAUNCHER_LOGIN);
         pkg.writeInt(type);
         this.sendPackage(pkg);
      }
      
      public function sendGetGoods(type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.EVERYDAY_ACTIVEPOINT);
         pkg.writeByte(ActivityPackageType.REGETACTIVEPOINT_REWARD);
         pkg.writeInt(type);
         this.sendPackage(pkg);
      }
      
      public function sendConsortiaBossInfo(type:int, callLevel:int = 1) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         pkg.writeInt(ConsortiaPackageType.CONSORTIA_BOSS_INFO);
         pkg.writeByte(type);
         pkg.writeInt(callLevel);
         this.sendPackage(pkg);
      }
      
      public function sendLatentEnergy(type:int, equipBagType:int, equipPlace:int, itemBagType:int = -1, itemPlace:int = -1) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LATENT_ENERGY);
         pkg.writeByte(type);
         pkg.writeInt(equipBagType);
         pkg.writeInt(equipPlace);
         if(type == 1)
         {
            pkg.writeInt(itemBagType);
            pkg.writeInt(itemPlace);
         }
         this.sendPackage(pkg);
      }
      
      public function sendWonderfulActivity(type:int, id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WONDERFUL_ACTIVITY);
         pkg.writeInt(type);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function requestWonderfulActInit(type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WONDERFUL_ACTIVITY_INIT);
         pkg.writeInt(type);
         this.sendPackage(pkg);
      }
      
      public function sendBattleCompanionGive(id:int, bagType:int, place:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.BATTLE_COMPANION_GIVE);
         pkg.writeInt(id);
         pkg.writeInt(bagType);
         pkg.writeInt(place);
         this.sendPackage(pkg);
      }
      
      public function addPetEquip(place:int, petIndex:int, bagType:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PET);
         pkg.writeByte(CrazyTankPackageType.ADD_PET_EQUIP);
         pkg.writeInt(bagType);
         pkg.writeInt(place);
         pkg.writeInt(petIndex);
         this.sendPackage(pkg);
      }
      
      public function delPetEquip(petIndex:int, type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PET);
         pkg.writeByte(CrazyTankPackageType.DEL_PET_EQUIP);
         pkg.writeInt(petIndex);
         pkg.writeInt(type);
         this.sendPackage(pkg);
      }
      
      public function necklaceStrength(num:int, place:int, type:int = 2) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.NECKLACE_STRENGTH);
         pkg.writeByte(type);
         pkg.writeInt(place);
         pkg.writeInt(num);
         this.sendPackage(pkg);
      }
      
      public function enterGodsRoads() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(GodsRoadsPkgType.ENTER_GODS_ROADS);
         this.sendPackage(pkg);
      }
      
      public function getGodsRoadsAwards(type:int, para:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(GodsRoadsPkgType.GET_AWARDS);
         pkg.writeInt(type);
         pkg.writeInt(para);
         this.sendPackage(pkg);
      }
      
      public function enterSuperWinner() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(SuperWinnerPackageType.ENTER_ROOM);
         this.sendPackage(pkg);
      }
      
      public function rollDiceInSuperWinner() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(SuperWinnerPackageType.ROLLS_DICES);
         this.sendPackage(pkg);
      }
      
      public function outSuperWinner() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(SuperWinnerPackageType.OUT_ROOM);
         this.sendPackage(pkg);
      }
      
      public function enterBuried() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEARCH_GOODS);
         pkg.writeByte(SearchGoodsPackageType.TRYENTER);
         this.sendPackage(pkg);
      }
      
      public function rollDice(bool:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEARCH_GOODS);
         pkg.writeByte(SearchGoodsPackageType.RollDice);
         pkg.writeBoolean(bool);
         this.sendPackage(pkg);
      }
      
      public function upgradeStartLevel(bool:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEARCH_GOODS);
         pkg.writeByte(SearchGoodsPackageType.UpgradeStartLevel);
         pkg.writeBoolean(bool);
         this.sendPackage(pkg);
      }
      
      public function refreshMap() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEARCH_GOODS);
         pkg.writeByte(SearchGoodsPackageType.Refresh);
         this.sendPackage(pkg);
      }
      
      public function takeCard(bool:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEARCH_GOODS);
         pkg.writeByte(SearchGoodsPackageType.TakeCard);
         pkg.writeBoolean(bool);
         this.sendPackage(pkg);
      }
      
      public function outCard() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEARCH_GOODS);
         pkg.writeByte(SearchGoodsPackageType.QuitTakeCard);
         this.sendPackage(pkg);
      }
      
      public function sendConsBatRequestPlayerInfo() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_BATTLE);
         pkg.writeByte(ConsBatPackageType.ADD_PLAYER);
         this.sendPackage(pkg);
      }
      
      public function sendConsBatMove(endX:int, endY:int, path:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_BATTLE);
         pkg.writeByte(ConsBatPackageType.PLAYER_MOVE);
         pkg.writeInt(endX);
         pkg.writeInt(endY);
         pkg.writeUTF(path);
         this.sendPackage(pkg);
      }
      
      public function sendConsBatChallenge(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_BATTLE);
         pkg.writeByte(ConsBatPackageType.CHALLENGE);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendConsBatExit() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_BATTLE);
         pkg.writeByte(ConsBatPackageType.DELETE_PLAYER);
         this.sendPackage(pkg);
      }
      
      public function sendConsBatConsume(type:int, isBind:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_BATTLE);
         pkg.writeByte(ConsBatPackageType.CONSUME);
         pkg.writeInt(type);
         pkg.writeBoolean(isBind);
         this.sendPackage(pkg);
      }
      
      public function sendConsBatUpdateScore(type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_BATTLE);
         pkg.writeByte(ConsBatPackageType.UPDATE_SCORE);
         pkg.writeByte(type);
         this.sendPackage(pkg);
      }
      
      public function enterDayActivity() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.EVERYDAY_ACTIVEPOINT);
         pkg.writeByte(ActivityPackageType.EVERYDAYACTIVEPOINT_DATA);
         this.sendPackage(pkg);
      }
      
      public function sendConsBatConfirmEnter() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSORTIA_BATTLE);
         pkg.writeByte(ConsBatPackageType.CONFIRM_ENTER);
         this.sendPackage(pkg);
      }
      
      public function sendUpdateSysDate() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SYS_DATE);
         this.sendPackage(pkg);
      }
      
      public function sendDragonBoatBuildOrDecorate(type:int, count:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.DRAGON_BOAT);
         pkg.writeByte(DragonBoatPackageType.BUILD_DECORATE);
         pkg.writeByte(type);
         pkg.writeInt(count);
         this.sendPackage(pkg);
      }
      
      public function sendDragonBoatRefreshBoatStatus() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.DRAGON_BOAT);
         pkg.writeByte(DragonBoatPackageType.REFRESH_BOAT_STATUS);
         this.sendPackage(pkg);
      }
      
      public function sendDragonBoatRefreshRank() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.DRAGON_BOAT);
         pkg.writeByte(DragonBoatPackageType.REFRESH_RANK);
         this.sendPackage(pkg);
      }
      
      public function sendDragonBoatExchange(goodsId:int, count:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.DRAGON_BOAT);
         pkg.writeByte(DragonBoatPackageType.EXCHANGE);
         pkg.writeInt(goodsId);
         pkg.writeInt(count);
         this.sendPackage(pkg);
      }
      
      public function requestUnWeddingPay(friendsID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.REQUEST_FRIENDS_PAY);
         pkg.writeByte(ChargePackageType.Request_For_Divorce);
         pkg.writeInt(friendsID);
         this.sendPackage(pkg);
      }
      
      public function requestShopPay(goodsIds:Array, types:Array, goodsTypes:Array, colors:Array, skins:Array, name:String, msg:String = "") : void
      {
         var len:int = int(goodsIds.length);
         var pkg:PackageOut = new PackageOut(ePackageType.REQUEST_FRIENDS_PAY);
         pkg.writeByte(ChargePackageType.Request_For_Shop);
         pkg.writeUTF(name);
         pkg.writeUTF(msg);
         pkg.writeInt(len);
         for(var i:int = 0; i < len; i++)
         {
            pkg.writeInt(goodsIds[i]);
            pkg.writeInt(types[i]);
            pkg.writeInt(goodsTypes[i]);
            pkg.writeUTF(colors[i]);
            pkg.writeUTF(skins[i]);
         }
         this.sendPackage(pkg);
      }
      
      public function requestAuctionPay(auctionID:int, name:String, msg:String = "") : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.REQUEST_FRIENDS_PAY);
         pkg.writeByte(ChargePackageType.Request_For_Auction);
         pkg.writeInt(auctionID);
         pkg.writeUTF(name);
         pkg.writeUTF(msg);
         this.sendPackage(pkg);
      }
      
      public function sendWantStrongBack(type:int, findBackType:Boolean, isBand:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FIND_BACK_INCOME);
         pkg.writeInt(type);
         pkg.writeBoolean(findBackType);
         pkg.writeBoolean(isBand);
         this.sendPackage(pkg);
      }
      
      public function isAcceptPayShop(isAcceptPay:Boolean, id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.REQUEST_FRIENDS_PAY);
         pkg.writeByte(ChargePackageType.Handle_For_Shop);
         pkg.writeInt(id);
         pkg.writeBoolean(isAcceptPay);
         this.sendPackage(pkg);
      }
      
      public function isAcceptPayAuc(isAcceptPay:Boolean, id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.REQUEST_FRIENDS_PAY);
         pkg.writeByte(ChargePackageType.Pay_For_Auction_Email);
         pkg.writeInt(id);
         pkg.writeBoolean(isAcceptPay);
         this.sendPackage(pkg);
      }
      
      public function sendForAuction(id:int, name:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.REQUEST_FRIENDS_PAY);
         pkg.writeByte(ChargePackageType.Pay_For_Auction);
         pkg.writeInt(id);
         pkg.writeUTF(name);
         this.sendPackage(pkg);
      }
      
      public function isAcceptPay(isAcceptPay:Boolean, id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.REQUEST_FRIENDS_PAY);
         pkg.writeByte(ChargePackageType.Handle_For_Divorce);
         pkg.writeInt(id);
         pkg.writeBoolean(isAcceptPay);
         this.sendPackage(pkg);
      }
      
      public function CampbattleEnterFight(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         pkg.writeByte(CampPackageType.ENTER_MONSTER_FIGHT);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function CampbattleRoleMove(zoneID:int, userID:int, p:Point) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         pkg.writeByte(CampPackageType.ROLE_MOVE);
         pkg.writeInt(p.x);
         pkg.writeInt(p.y);
         pkg.writeInt(zoneID);
         pkg.writeInt(userID);
         this.sendPackage(pkg);
      }
      
      public function changeMap() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         pkg.writeByte(CampPackageType.MAP_CHANGE);
         this.sendPackage(pkg);
      }
      
      public function outCampBatttle() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         pkg.writeByte(CampPackageType.REMOVE_ROLE);
         this.sendPackage(pkg);
      }
      
      public function captureMap(bool:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         pkg.writeByte(CampPackageType.CAPTURE_MAP);
         pkg.writeBoolean(bool);
         this.sendPackage(pkg);
      }
      
      public function requestPRankList() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         pkg.writeByte(CampPackageType.PER_SCORE_RANK);
         this.sendPackage(pkg);
      }
      
      public function requestCRankList() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         pkg.writeByte(CampPackageType.CAMP_SOCER_RANK);
         this.sendPackage(pkg);
      }
      
      public function enterPTPFight(zoneID:int, userID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         pkg.writeByte(CampPackageType.PVP_TO_FIGHT);
         pkg.writeInt(zoneID);
         pkg.writeInt(userID);
         this.sendPackage(pkg);
      }
      
      public function returnToPve() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         pkg.writeByte(CampPackageType.INIT_SECEN);
         this.sendPackage(pkg);
      }
      
      public function resurrect(isBind:Boolean, isCost:Boolean = true) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         pkg.writeByte(CampPackageType.RESURRECT);
         pkg.writeBoolean(isCost);
         pkg.writeBoolean(isBind);
         this.sendPackage(pkg);
      }
      
      public function sendGroupPurchaseRefreshData() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GROUP_PURCHASE);
         pkg.writeByte(GroupPurchasePackageType.REFRESH_DATA);
         this.sendPackage(pkg);
      }
      
      public function sendGroupPurchaseRefreshRankData() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GROUP_PURCHASE);
         pkg.writeByte(GroupPurchasePackageType.REFRESH_RANK_DATA);
         this.sendPackage(pkg);
      }
      
      public function sendGroupPurchaseBuy(num:int, isBand:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GROUP_PURCHASE);
         pkg.writeByte(GroupPurchasePackageType.BUY);
         pkg.writeInt(num);
         pkg.writeBoolean(isBand);
         this.sendPackage(pkg);
      }
      
      public function sendRegressPkg() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         pkg.writeByte(RegressPackageType.REGRESS_PACKS);
         this.sendPackage(pkg);
      }
      
      public function sendRegressGetAwardPkg(awardID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         pkg.writeByte(RegressPackageType.REGRESS_GETPACKS);
         pkg.writeInt(awardID);
         this.sendPackage(pkg);
      }
      
      public function sendRegressCheckPlayer(playerName:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         pkg.writeByte(RegressPackageType.REGRESS_CHECK);
         pkg.writeUTF(playerName);
         this.sendPackage(pkg);
      }
      
      public function sendRegressApplyEnable() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         pkg.writeByte(RegressPackageType.REGRESS_APPLY_ENABLE);
         this.sendPackage(pkg);
      }
      
      public function sendRegressApllyPacks() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         pkg.writeByte(RegressPackageType.REGRESS_APPLYPACKS);
         this.sendPackage(pkg);
      }
      
      public function sendRegressCall(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         pkg.writeByte(RegressPackageType.REGRESS_CALL);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendRegressRecvPacks() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         pkg.writeByte(RegressPackageType.REGRESS_REVCPACKS);
         this.sendPackage(pkg);
      }
      
      public function sendRegressTicketInfo() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         pkg.writeByte(RegressPackageType.REGRESS_GET_TICKET);
         this.sendPackage(pkg);
      }
      
      public function sendRegressTicket() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         pkg.writeByte(RegressPackageType.REGRESS_GET_TICKETINFO);
         this.sendPackage(pkg);
      }
      
      public function sendExpBlessedData() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.EVERYDAY_ACTIVEPOINT);
         pkg.writeByte(ActivityPackageType.GET_EXPBLESSED_DATA);
         this.sendPackage(pkg);
      }
      
      public function sendGameTrusteeship(flag:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.GAME_TRUSTEESHIP);
         pkg.writeBoolean(flag);
         this.sendPackage(pkg);
      }
      
      public function sendInitTreasueHunting() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEPARATE_ACTIVITY);
         pkg.writeByte(CrazyTankPackageType.INIT_TREASURE);
         this.sendPackage(pkg);
      }
      
      public function sendPayForHunting(isBind:Boolean, count:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEPARATE_ACTIVITY);
         pkg.writeByte(CrazyTankPackageType.PAY_FOR_HUNTING);
         pkg.writeBoolean(isBind);
         pkg.writeInt(count);
         this.sendPackage(pkg);
      }
      
      public function getAllTreasure() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEPARATE_ACTIVITY);
         pkg.writeByte(CrazyTankPackageType.GET_ALL_TREASURE);
         this.sendPackage(pkg);
      }
      
      public function updateTreasureBag() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEPARATE_ACTIVITY);
         pkg.writeByte(CrazyTankPackageType.UPDATE_TREASURE_BAG);
         this.sendPackage(pkg);
      }
      
      public function sendHuntingByScore() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEPARATE_ACTIVITY);
         pkg.writeByte(CrazyTankPackageType.HUNTING_BY_SCORE);
         this.sendPackage(pkg);
      }
      
      public function sendConvertScore(isConver:Boolean, totalSorce:int = 0, lotteryScore:int = 0) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEPARATE_ACTIVITY);
         pkg.writeByte(CrazyTankPackageType.CONVERT_SCORE);
         pkg.writeBoolean(isConver);
         pkg.writeInt(totalSorce);
         pkg.writeInt(lotteryScore);
         this.sendPackage(pkg);
      }
      
      public function sendSevenDoubleCallCar(carType:int, isBand:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEVEN_DOUBLE);
         pkg.writeByte(SevenDoublePackageType.CALL);
         pkg.writeInt(carType);
         pkg.writeBoolean(isBand);
         this.sendPackage(pkg);
      }
      
      public function sendSevenDoubleStartGame(isBand:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEVEN_DOUBLE);
         pkg.writeByte(SevenDoublePackageType.START_GAME);
         pkg.writeBoolean(isBand);
         this.sendPackage(pkg);
      }
      
      public function sendSevenDoubleCancelGame() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEVEN_DOUBLE);
         pkg.writeByte(SevenDoublePackageType.CANCEL_GAME);
         this.sendPackage(pkg);
      }
      
      public function sendSevenDoubleReady() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEVEN_DOUBLE);
         pkg.writeByte(SevenDoublePackageType.READY);
         this.sendPackage(pkg);
      }
      
      public function sendSevenDoubleMove() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEVEN_DOUBLE);
         pkg.writeByte(SevenDoublePackageType.MOVE);
         this.sendPackage(pkg);
      }
      
      public function sendSevenDoubleUseSkill(type:int, isBand:Boolean, isFree:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEVEN_DOUBLE);
         pkg.writeByte(SevenDoublePackageType.USE_SKILL);
         pkg.writeInt(type);
         pkg.writeBoolean(isBand);
         pkg.writeBoolean(isFree);
         this.sendPackage(pkg);
      }
      
      public function sendSevenDoubleCanEnter() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEVEN_DOUBLE);
         pkg.writeByte(SevenDoublePackageType.IS_CAN_ENTER);
         this.sendPackage(pkg);
      }
      
      public function sendBuyEnergy(isBand:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MISSION_ENERGY);
         pkg.writeBoolean(isBand);
         this.sendPackage(pkg);
      }
      
      public function sendSevenDoubleEnterOrLeaveScene(isEnter:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEVEN_DOUBLE);
         pkg.writeByte(SevenDoublePackageType.ENTER_OR_LEAVE_SCENE);
         pkg.writeBoolean(isEnter);
         this.sendPackage(pkg);
      }
      
      public function sendWonderfulActivityGetReward(sendInfoVec:Vector.<SendGiftInfo>) : void
      {
         var j:int = 0;
         var pkg:PackageOut = new PackageOut(ePackageType.WONDERFUL_GETREWARD);
         pkg.writeInt(sendInfoVec.length);
         for(var i:int = 0; i < sendInfoVec.length; i++)
         {
            pkg.writeUTF(sendInfoVec[i].activityId);
            pkg.writeInt(sendInfoVec[i].awardCount);
            pkg.writeInt(sendInfoVec[i].giftIdArr.length);
            for(j = 0; j < sendInfoVec[i].giftIdArr.length; j++)
            {
               pkg.writeUTF(sendInfoVec[i].giftIdArr[j]);
            }
         }
         this.sendPackage(pkg);
      }
      
      public function sendButChristmasGoods(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(ChristmasPackageType.CHRISTMAS_PACKS);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function enterChristmasRoomIsTrue() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(ChristmasPackageType.CHRISTMAS_PLAYERING_SNOWMAN_ENTER);
         pkg.writeByte(0);
         this.sendPackage(pkg);
      }
      
      public function enterChristmasRoom(point:Point) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(ChristmasPackageType.CHRISTMAS_PLAYERING_SNOWMAN_ENTER);
         pkg.writeByte(2);
         pkg.writeInt(point.x);
         pkg.writeInt(point.y);
         this.sendPackage(pkg);
      }
      
      public function enterMakingSnowManRoom() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(ChristmasPackageType.CHRISTMAS_MAKING_SNOWMAN_ENTER);
         this.sendPackage(pkg);
      }
      
      public function getPacksToPlayer(num:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(ChristmasPackageType.GET_PAKCS_TO_PLAYER);
         pkg.writeByte(num);
         this.sendPackage(pkg);
      }
      
      public function sendLeaveChristmasRoom() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(ChristmasPackageType.CHRISTMAS_PLAYERING_SNOWMAN_ENTER);
         pkg.writeByte(1);
         this.sendPackage(pkg);
      }
      
      public function sendChristmasRoomMove(endX:int, endY:int, path:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(ChristmasPackageType.MOVE);
         pkg.writeInt(endX);
         pkg.writeInt(endY);
         pkg.writeUTF(path);
         this.sendPackage(pkg);
      }
      
      public function sendChristmasUpGrade(num:int, isDouble:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(ChristmasPackageType.FIGHT_SPIRIT_LEVELUP);
         pkg.writeInt(num);
         pkg.writeBoolean(isDouble);
         this.sendPackage(pkg);
      }
      
      public function sendStartFightWithMonster(pMonsterID:int) : void
      {
         var p:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         p.writeByte(ChristmasPackageType.FIGHT_MONSTER);
         p.writeInt(pMonsterID);
         this.sendPackage(p);
      }
      
      public function sendBuyPlayingSnowmanVolumes() : void
      {
         var p:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         p.writeByte(ChristmasPackageType.CHRISTMAS_BUY_TIMER);
         this.sendPackage(p);
      }
      
      public function sendLuckyStarEnter() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         pkg.writeInt(NewChickenBoxPackageType.ENTER_GAME);
         this.sendPackage(pkg);
      }
      
      public function sendLuckyStarClose() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         pkg.writeInt(NewChickenBoxPackageType.CLOSE_GAME);
         this.sendPackage(pkg);
      }
      
      public function sendLuckyStarTurnComplete() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         pkg.writeInt(NewChickenBoxPackageType.TURN_COMPLETE);
         this.sendPackage(pkg);
      }
      
      public function sendLuckyStarTurn() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         pkg.writeInt(NewChickenBoxPackageType.START_TURN);
         this.sendPackage(pkg);
      }
      
      public function sendRingStationGetInfo() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.RING_STATION);
         pkg.writeByte(RingStationPackageType.RINGSTATION_VIEWINFO);
         this.sendPackage(pkg);
      }
      
      public function sendBuyBattleCountOrTime(isBand:Boolean, timeFlag:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.RING_STATION);
         pkg.writeByte(RingStationPackageType.RINGSTATION_BUYCOUNTORTIME);
         pkg.writeBoolean(timeFlag);
         pkg.writeBoolean(isBand);
         this.sendPackage(pkg);
      }
      
      public function sendRingStationChallenge(userId:int, rank:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.RING_STATION);
         pkg.writeByte(RingStationPackageType.RINGSTATION_CHALLENGE);
         pkg.writeInt(userId);
         pkg.writeInt(rank);
         this.sendPackage(pkg);
      }
      
      public function sendRingStationArmory() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.RING_STATION);
         pkg.writeByte(RingStationPackageType.RINGSTATION_ARMORY);
         this.sendPackage(pkg);
      }
      
      public function sendRingStationBattleField() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.RING_STATION);
         pkg.writeByte(RingStationPackageType.RINGSTATION_NEWBATTLEFIELD);
         this.sendPackage(pkg);
      }
      
      public function sendRingStationFightFlag() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.RING_STATION);
         pkg.writeByte(RingStationPackageType.RINGSTATION_FIGHTFLAG);
         this.sendPackage(pkg);
      }
      
      public function sendRouletteRun() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEPARATE_ACTIVITY);
         pkg.writeByte(CrazyTankPackageType.DAWN_LOTTERY);
         this.sendPackage(pkg);
      }
      
      public function getBackLockPwdByPhone(step:int, str1:String = "") : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.BAGLOCK_PWD);
         pkg.writeByte(CrazyTankPackageType.GET_BACK_BY_PHONE);
         pkg.writeInt(step);
         pkg.writeUTF(str1);
         this.sendPackage(pkg);
      }
      
      public function getBackLockPwdByQuestion(step:int, str1:String = "", str2:String = "") : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.BAGLOCK_PWD);
         pkg.writeByte(CrazyTankPackageType.GET_BACK_BY_QUESTION);
         pkg.writeInt(step);
         pkg.writeUTF(str1);
         pkg.writeUTF(str2);
         this.sendPackage(pkg);
      }
      
      public function deletePwdQuestion(step:int, str1:String = "") : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.BAGLOCK_PWD);
         pkg.writeByte(CrazyTankPackageType.DELETE_QUESTION);
         pkg.writeInt(step);
         pkg.writeUTF(str1);
         this.sendPackage(pkg);
      }
      
      public function deletePwdByPhone(step:int, str1:String = "") : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.BAGLOCK_PWD);
         pkg.writeByte(CrazyTankPackageType.DELETE_PWD_BY_PHONE);
         pkg.writeInt(step);
         pkg.writeUTF(str1);
         this.sendPackage(pkg);
      }
      
      public function checkPhoneBind() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.BAGLOCK_PWD);
         pkg.writeByte(CrazyTankPackageType.CHECK_PHONE_BINDING);
         this.sendPackage(pkg);
      }
      
      public function sendActivityDungeonNextPoints(type:int, flag:Boolean, playerID:int = 0) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.ADD_ANIMATION);
         pkg.writeByte(type);
         pkg.writeBoolean(flag);
         pkg.writeInt(playerID);
         this.sendPackage(pkg);
      }
      
      public function sendGuildMemberWeekStarEnter() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GUILDMEMBERWEEK_SYSTEM);
         pkg.writeByte(GuildMemberWeekPackageType.ENTER_GAME);
         this.sendPackage(pkg);
      }
      
      public function sendGuildMemberWeekStarClose() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GUILDMEMBERWEEK_SYSTEM);
         pkg.writeByte(GuildMemberWeekPackageType.CLOSE);
         this.sendPackage(pkg);
      }
      
      public function sendGuildMemberWeekAddRanking(data:Array) : void
      {
         var count:int = int(data.length);
         var pkg:PackageOut = new PackageOut(ePackageType.GUILDMEMBERWEEK_SYSTEM);
         pkg.writeByte(GuildMemberWeekPackageType.SEND_ADDRUNKING);
         pkg.writeInt(count);
         for(var i:uint = 0; i < count; i++)
         {
            pkg.writeInt(data[i]);
         }
         this.sendPackage(pkg);
      }
      
      public function sendSignMsg(msg:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.RING_STATION);
         pkg.writeByte(RingStationPackageType.RINGSTATION_SENDSIGNMSG);
         pkg.writeUTF(msg);
         this.sendPackage(pkg);
      }
      
      public function sendLanternRiddlesQuestion() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(LanternriddlesPackageType.LANTERNRIDDLES_QUESTION);
         this.sendPackage(pkg);
      }
      
      public function sendLanternRiddlesAnswer(id:int, index:int, option:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(LanternriddlesPackageType.LANTERNRIDDLES_ANSWER);
         pkg.writeInt(id);
         pkg.writeInt(index);
         pkg.writeInt(option);
         this.sendPackage(pkg);
      }
      
      public function sendLanternRiddlesUseSkill(id:int, index:int, type:int, isBand:Boolean = true) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(LanternriddlesPackageType.LANTERNRIDDLES_SKILL);
         pkg.writeInt(id);
         pkg.writeInt(index);
         pkg.writeInt(type);
         pkg.writeBoolean(false);
         this.sendPackage(pkg);
      }
      
      public function sendLanternRiddlesRankInfo() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(LanternriddlesPackageType.LANTERNRIDDLES_RANKINFO);
         this.sendPackage(pkg);
      }
      
      public function sendCatchBeastBegin() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(CatchBeastPackageType.CATCHBEAST_BEGIN);
         this.sendPackage(pkg);
      }
      
      public function sendCatchBeastViewInfo() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(CatchBeastPackageType.CATCHBEAST_VIEWINFO);
         this.sendPackage(pkg);
      }
      
      public function sendCatchBeastChallenge() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(CatchBeastPackageType.CATCHBEAST_CHALLENGE);
         this.sendPackage(pkg);
      }
      
      public function sendCatchBeastBuyBuff(isBind:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(CatchBeastPackageType.CATCHBEAST_BUYBUFF);
         pkg.writeBoolean(isBind);
         this.sendPackage(pkg);
      }
      
      public function sendCatchBeastGetAward(boxID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(CatchBeastPackageType.CATCHBEAST_GETAWARD);
         pkg.writeInt(boxID);
         this.sendPackage(pkg);
      }
      
      public function sendAccumulativeLoginAward(templeteId:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACCUMULATIVELOGIN_AWARD);
         pkg.writeInt(templeteId);
         this.sendPackage(pkg);
      }
      
      public function sendAvatarCollectionActive(id:int, itemId:int, sex:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.AVATAR_COLLECTION);
         pkg.writeByte(AvatarCollectionPackageType.ACTIVE);
         pkg.writeInt(id);
         pkg.writeInt(itemId);
         pkg.writeInt(sex);
         this.sendPackage(pkg);
      }
      
      public function sendAvatarCollectionDelayTime(id:int, count:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.AVATAR_COLLECTION);
         pkg.writeByte(AvatarCollectionPackageType.DELAY_TIME);
         pkg.writeInt(id);
         pkg.writeInt(count);
         this.sendPackage(pkg);
      }
      
      public function setCurrentModel(index:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PLAYER_DRESS);
         pkg.writeByte(PlayerDressType.CURRENT_MODEL);
         pkg.writeInt(index);
         this.sendPackage(pkg);
      }
      
      public function saveDressModel(index:int, arr:Array) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PLAYER_DRESS);
         pkg.writeByte(PlayerDressType.GET_DRESS_MODEL);
         pkg.writeInt(index);
         pkg.writeInt(arr.length);
         for(var i:int = 0; i <= arr.length - 1; i++)
         {
            pkg.writeInt(BagInfo.EQUIPBAG);
            pkg.writeInt(arr[i]);
         }
         this.sendPackage(pkg);
      }
      
      public function foldDressItem(arr:Array) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PLAYER_DRESS);
         pkg.writeByte(PlayerDressType.FOLD_DRESS);
         pkg.writeInt(arr.length);
         for(var i:int = 0; i <= arr.length - 1; i++)
         {
            pkg.writeInt(BagInfo.EQUIPBAG);
            pkg.writeInt(arr[i].sPlace);
            pkg.writeInt(BagInfo.EQUIPBAG);
            pkg.writeInt(arr[i].tPlace);
         }
         this.sendPackage(pkg);
      }
      
      public function lockDressBag() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PLAYER_DRESS);
         pkg.writeByte(PlayerDressType.LOCK_DRESSBAG);
         this.sendPackage(pkg);
      }
      
      public function receiveLandersAward() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.RING_STATION);
         pkg.writeByte(RingStationPackageType.LANDERSAWARD_GET);
         this.sendPackage(pkg);
      }
      
      public function getFlowerRankInfo(type:int, page:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FLOWER_GIVING);
         pkg.writeByte(FlowerGivingType.GET_FLOWER_RANK);
         pkg.writeInt(type);
         pkg.writeInt(page);
         this.sendPackage(pkg);
      }
      
      public function sendGetFlowerReward(type:int, index:int = 0) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FLOWER_GIVING);
         pkg.writeByte(FlowerGivingType.GET_REWARD);
         pkg.writeInt(type);
         pkg.writeInt(index);
         this.sendPackage(pkg);
      }
      
      public function getFlowerRewardStatus() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FLOWER_GIVING);
         pkg.writeByte(FlowerGivingType.REWARD_INFO);
         this.sendPackage(pkg);
      }
      
      public function sendFlower(playerName:String, num:int, message:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FLOWER_GIVING);
         pkg.writeByte(FlowerGivingType.GIVE_FLOWER);
         pkg.writeUTF(playerName);
         pkg.writeInt(num);
         pkg.writeUTF(message);
         this.sendPackage(pkg);
      }
      
      public function sendFlowerRecord() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FLOWER_GIVING);
         pkg.writeByte(FlowerGivingType.GET_RECORD);
         this.sendPackage(pkg);
      }
      
      public function sendUpdateIntegral() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         pkg.writeByte(RegressPackageType.REGRESS_UPDATE_INTEGRAL);
         this.sendPackage(pkg);
      }
      
      public function sendBuyRegressIntegralGoods(id:int, num:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         pkg.writeByte(RegressPackageType.REGRESS_INTEGRAL_BUY);
         pkg.writeInt(id);
         pkg.writeInt(num);
         this.sendPackage(pkg);
      }
      
      public function sendPlayerExit(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.NEW_HALL);
         pkg.writeByte(NewHallPackageType.PLAYEREXIT);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendOtherPlayerInfo() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.NEW_HALL);
         pkg.writeByte(NewHallPackageType.PLAYERINFO);
         this.sendPackage(pkg);
      }
      
      public function sendPlayerPos(x:int, y:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.NEW_HALL);
         pkg.writeByte(NewHallPackageType.PLAYERMOVE);
         pkg.writeInt(x);
         pkg.writeInt(y);
         this.sendPackage(pkg);
      }
      
      public function sendAddNewPlayer(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.NEW_HALL);
         pkg.writeByte(NewHallPackageType.ADDPLAYE);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendModifyNewPlayerDress() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.NEW_HALL);
         pkg.writeByte(NewHallPackageType.MODIFYDRESS);
         this.sendPackage(pkg);
      }
      
      public function sendUpdatePets(flag:Boolean, id:int, petsID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.NEW_HALL);
         pkg.writeByte(NewHallPackageType.UPDATEPETS);
         pkg.writeBoolean(flag);
         pkg.writeInt(id);
         pkg.writeInt(petsID);
         this.sendPackage(pkg);
      }
      
      public function sendNewHallPlayerHid(flag:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.NEW_HALL);
         pkg.writeByte(NewHallPackageType.PLAYERHID);
         pkg.writeBoolean(flag);
         this.sendPackage(pkg);
      }
      
      public function sendNewHallBattle() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.NEW_HALL);
         pkg.writeByte(NewHallPackageType.NEWHALL_BATTLE);
         this.sendPackage(pkg);
      }
      
      public function sendLoadOtherPlayer() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.NEW_HALL);
         pkg.writeByte(NewHallPackageType.PLAYERSHOW);
         this.sendPackage(pkg);
      }
      
      public function sendHorseChangeHorse(tag:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HORSE);
         pkg.writeByte(HorsePackageType.CHANGE_HORSE);
         pkg.writeInt(tag);
         this.sendPackage(pkg);
      }
      
      public function sendActiveHorsePicCherish(place:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HORSE);
         pkg.writeByte(HorsePackageType.ACTIVE_HORSEPICCHERISH);
         pkg.writeInt(place);
         this.sendPackage(pkg);
      }
      
      public function sendHorseUpHorse(count:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HORSE);
         pkg.writeByte(HorsePackageType.UP_HORSE);
         pkg.writeInt(count);
         this.sendPackage(pkg);
      }
      
      public function sendHorseUpSkill(skillId:int, count:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HORSE);
         pkg.writeByte(HorsePackageType.UP_SKILL);
         pkg.writeInt(skillId);
         pkg.writeInt(count);
         this.sendPackage(pkg);
      }
      
      public function sendHorseTakeUpDownSkill(skillId:int, status:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HORSE);
         pkg.writeByte(HorsePackageType.TAKE_UP_DOWN_SKILL);
         pkg.writeInt(skillId);
         pkg.writeInt(status);
         this.sendPackage(pkg);
      }
      
      public function sendBombKingStartBattle() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.BOMB_KING);
         pkg.writeByte(BombKingType.START_BATTLE);
         this.sendPackage(pkg);
      }
      
      public function updateBombKingMainFrame() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.BOMB_KING);
         pkg.writeByte(BombKingType.UPDATE_MAIN_FRAME);
         this.sendPackage(pkg);
      }
      
      public function updateBombKingRank(type:int, page:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.BOMB_KING);
         pkg.writeByte(BombKingType.RANK_BY_PAGE);
         pkg.writeInt(type);
         pkg.writeInt(page);
         this.sendPackage(pkg);
      }
      
      public function updateBombKingBattleLog() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.BOMB_KING);
         pkg.writeByte(BombKingType.BATTLE_LOG);
         this.sendPackage(pkg);
      }
      
      public function updateBKingItemEquip(useId:int, areaId:int, type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.BOMB_KING);
         pkg.writeByte(BombKingType.BKING_ITEM_EQUIP);
         pkg.writeInt(useId);
         pkg.writeInt(areaId);
         pkg.writeInt(type);
         this.sendPackage(pkg);
      }
      
      public function getBKingStatueInfo() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.BOMB_KING);
         pkg.writeByte(BombKingType.STATUE_INFO);
         this.sendPackage(pkg);
      }
      
      public function requestBKingShowTip() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.BOMB_KING);
         pkg.writeByte(BombKingType.SHOW_TIP);
         this.sendPackage(pkg);
      }
      
      public function sendCollectionSceneEnter() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.COLLECTION_TASK);
         pkg.writeByte(CollectionTaskEvent.INIT_PLAYERS);
         this.sendPackage(pkg);
      }
      
      public function sendCollectionSceneMove(endX:int, endY:int, path:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.COLLECTION_TASK);
         pkg.writeByte(CollectionTaskEvent.WALK);
         pkg.writeInt(endX);
         pkg.writeInt(endY);
         pkg.writeUTF(path);
         this.sendPackage(pkg);
      }
      
      public function sendCollectionComplete(collectedId:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.COLLECTION_TASK);
         pkg.writeByte(CollectionTaskEvent.COLLECT);
         pkg.writeInt(collectedId);
         this.sendPackage(pkg);
      }
      
      public function sendLeaveCollectionScene() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.COLLECTION_TASK);
         pkg.writeByte(CollectionTaskEvent.QUIT);
         this.sendPackage(pkg);
      }
      
      public function sendPetRisingStar(templeteId:int, count:int, place:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PET);
         pkg.writeByte(CrazyTankPackageType.PET_RISINGSTAR);
         pkg.writeInt(templeteId);
         pkg.writeInt(count);
         pkg.writeInt(place);
         this.sendPackage(pkg);
      }
      
      public function sendPetEvolution(templeteId:int, count:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PET);
         pkg.writeByte(CrazyTankPackageType.PET_EVOLUTION);
         pkg.writeInt(templeteId);
         pkg.writeInt(count);
         this.sendPackage(pkg);
      }
      
      public function sendPetFormInfo() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PET);
         pkg.writeByte(CrazyTankPackageType.PET_FORMINFO);
         this.sendPackage(pkg);
      }
      
      public function sendPetFollowOrCall(flag:Boolean, id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PET);
         pkg.writeByte(CrazyTankPackageType.PET_FOLLOW);
         pkg.writeBoolean(flag);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendPetWake(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PET);
         pkg.writeByte(CrazyTankPackageType.PET_WAKE);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendEscortCallCar(carType:int, isBand:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ESCORT);
         pkg.writeByte(EscortPackageType.CALL);
         pkg.writeInt(carType);
         pkg.writeBoolean(isBand);
         this.sendPackage(pkg);
      }
      
      public function sendEscortStartGame(isBand:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ESCORT);
         pkg.writeByte(EscortPackageType.START_GAME);
         pkg.writeBoolean(isBand);
         this.sendPackage(pkg);
      }
      
      public function sendEscortCancelGame() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ESCORT);
         pkg.writeByte(EscortPackageType.CANCEL_GAME);
         this.sendPackage(pkg);
      }
      
      public function sendEscortReady() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ESCORT);
         pkg.writeByte(EscortPackageType.READY);
         this.sendPackage(pkg);
      }
      
      public function sendEscortMove() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ESCORT);
         pkg.writeByte(EscortPackageType.MOVE);
         this.sendPackage(pkg);
      }
      
      public function sendEscortUseSkill(type:int, isBand:Boolean, isFree:Boolean, otherId:int = 0, otherZone:int = -1) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ESCORT);
         pkg.writeByte(EscortPackageType.USE_SKILL);
         pkg.writeInt(type);
         pkg.writeBoolean(isBand);
         pkg.writeBoolean(isFree);
         pkg.writeInt(otherId);
         pkg.writeInt(otherZone);
         this.sendPackage(pkg);
      }
      
      public function sendEscortCanEnter() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ESCORT);
         pkg.writeByte(EscortPackageType.IS_CAN_ENTER);
         this.sendPackage(pkg);
      }
      
      public function sendEscortEnterOrLeaveScene(isEnter:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ESCORT);
         pkg.writeByte(EscortPackageType.ENTER_OR_LEAVE_SCENE);
         pkg.writeBoolean(isEnter);
         this.sendPackage(pkg);
      }
      
      public function sendPeerID(zoneID:int, userID:int, peerID:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PEER_ID);
         pkg.writeInt(zoneID);
         pkg.writeInt(userID);
         pkg.writeUTF(peerID);
         this.sendPackage(pkg);
      }
      
      public function exploreMagicStone(type:int, isBind:Boolean, count:int = 1) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MAGIC_STONE);
         pkg.writeByte(MagicStoneType.EXPLORE_MAGIC_STONE);
         pkg.writeInt(type);
         pkg.writeBoolean(isBind);
         pkg.writeInt(count);
         this.sendPackage(pkg);
      }
      
      public function getMagicStoneScore() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MAGIC_STONE);
         pkg.writeByte(MagicStoneType.MAGIC_STONE_SCORE);
         this.sendPackage(pkg);
      }
      
      public function convertMgStoneScore(goodsId:int, bind:Boolean = true, count:int = 1) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MAGIC_STONE);
         pkg.writeByte(MagicStoneType.CONVERT_SCORE);
         pkg.writeInt(goodsId);
         pkg.writeBoolean(bind);
         pkg.writeInt(count);
         this.sendPackage(pkg);
      }
      
      public function moveMagicStone(sourcePlace:int, targetPlace:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MAGIC_STONE);
         pkg.writeByte(MagicStoneType.MOVE_PLACE);
         pkg.writeInt(sourcePlace);
         pkg.writeInt(targetPlace);
         this.sendPackage(pkg);
      }
      
      public function lockMagicStone(place:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MAGIC_STONE);
         pkg.writeByte(MagicStoneType.LOCK_MAGIC_STONE);
         pkg.writeInt(place);
         this.sendPackage(pkg);
      }
      
      public function updateMagicStone(pSlots:Array) : void
      {
         var o:int = 0;
         var pkg:PackageOut = new PackageOut(ePackageType.MAGIC_STONE);
         pkg.writeByte(MagicStoneType.LEVEL_UP);
         pkg.writeInt(pSlots.length);
         for each(o in pSlots)
         {
            pkg.writeInt(o);
         }
         this.sendPackage(pkg);
      }
      
      public function sortMgStoneBag(array:Array, startPlace:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MAGIC_STONE);
         pkg.writeByte(MagicStoneType.SORT_BAG);
         pkg.writeInt(array.length);
         for(var i:int = 0; i < array.length; i++)
         {
            pkg.writeInt(array[i].Place);
            pkg.writeInt(i + startPlace);
         }
         this.sendPackage(pkg);
      }
      
      public function updateRemainCount() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MAGIC_STONE);
         pkg.writeByte(MagicStoneType.UPDATE_REMAIN_COUNT);
         this.sendPackage(pkg);
      }
      
      public function updateConsumeRank() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CONSUME_RANK);
         this.sendPackage(pkg);
      }
      
      public function sendEntertainment() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(EntertainmentPackageType.GET_SCORE);
         this.sendPackage(pkg);
      }
      
      public function buyEntertainment(bol:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(EntertainmentPackageType.BUY_ICON);
         pkg.writeBoolean(bol);
         this.sendPackage(pkg);
      }
      
      public function sendFastAuctionBugle(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FAST_AUCTION_SMALL_BUGLE);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function sendLightRoadStarEnter() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LIGHTROAD_SYSTEM);
         pkg.writeByte(LightRoadPackageType.ENTER_GAME);
         this.sendPackage(pkg);
      }
      
      public function lightRoadPointWork(space:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.LIGHTROAD_SYSTEM);
         pkg.writeByte(LightRoadPackageType.BECHOOSE_POINT);
         pkg.writeInt(space);
         this.sendPackage(pkg);
      }
      
      public function sevenDayTarget_enter(ishall:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEVENDAYTARGET_GODSROADS);
         pkg.writeByte(SevenDayTargetPackageType.SEVENDAYTARGET_ENTER);
         pkg.writeBoolean(ishall);
         this.sendPackage(pkg);
      }
      
      public function newPlayerReward_enter() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEVENDAYTARGET_GODSROADS);
         pkg.writeByte(SevenDayTargetPackageType.NEWPLAYERREWARD_ENTER);
         this.sendPackage(pkg);
      }
      
      public function sevenDayTarget_getReward(qustionID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEVENDAYTARGET_GODSROADS);
         pkg.writeByte(SevenDayTargetPackageType.SEVENDAYTARGET_GET_REWARD);
         pkg.writeInt(qustionID);
         this.sendPackage(pkg);
      }
      
      public function newPlayerReward_getReward(qustionID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SEVENDAYTARGET_GODSROADS);
         pkg.writeByte(SevenDayTargetPackageType.NEWPLAYERREWARD_GET_REWARD);
         pkg.writeInt(qustionID);
         this.sendPackage(pkg);
      }
      
      public function sendChickActivationOpenKey(strKey:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         pkg.writeInt(ChickActivationType.CHICKACTIVATION);
         pkg.writeInt(ChickActivationType.CHICKACTIVATION_OPENKEY);
         pkg.writeUTF(strKey);
         this.sendPackage(pkg);
      }
      
      public function sendChickActivationGetAward(index:int, levelIndex:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         pkg.writeInt(ChickActivationType.CHICKACTIVATION);
         pkg.writeInt(ChickActivationType.CHICKACTIVATION_GETAWARD);
         pkg.writeInt(index);
         pkg.writeInt(levelIndex);
         this.sendPackage(pkg);
      }
      
      public function sendChickActivationQuery() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         pkg.writeInt(ChickActivationType.CHICKACTIVATION);
         pkg.writeInt(ChickActivationType.CHICKACTIVATION_QUERY);
         this.sendPackage(pkg);
      }
      
      public function DDPlayEnter() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(DDPlayType.ENTER_DDPLAY);
         this.sendPackage(pkg);
      }
      
      public function DDPlayStart() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(DDPlayType.DDPLAY_START);
         this.sendPackage(pkg);
      }
      
      public function DDPlayExchange(num:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(DDPlayType.DDPLAY_EXCHANGE);
         pkg.writeInt(num);
         this.sendPackage(pkg);
      }
      
      public function sendBoguAdventureEnter() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(BoguAdventureType.ENTER_BOGUADVENTURE);
         this.sendPackage(pkg);
      }
      
      public function sendBoguAdventureWalkInfo(type:int, index:int = 0) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(BoguAdventureType.UPDATE_CELL);
         pkg.writeInt(type);
         if(type != 3)
         {
            pkg.writeInt(index);
         }
         this.sendPackage(pkg);
      }
      
      public function sendBoguAdventureUpdateGame(type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(BoguAdventureType.REVIVE_GAME);
         pkg.writeInt(type);
         this.sendPackage(pkg);
      }
      
      public function sendBoguAdventureAcquireAward(type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(BoguAdventureType.ACQUIRE_AWARD);
         pkg.writeInt(type);
         this.sendPackage(pkg);
      }
      
      public function sendOutBoguAdventure() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(BoguAdventureType.OUT_BOGUADVENTURE);
         this.sendPackage(pkg);
      }
      
      public function sendGetShopBuyLimitedCount() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SHOP_BUYLIMITEDCOUNT);
         this.sendPackage(pkg);
      }
      
      public function sendGrowthPackageGetItems($index:int) : void
      {
         var p:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         p.writeInt(GrowthPackageType.GROWTHPACKAGE);
         p.writeInt(GrowthPackageType.GROWTHPACKAGE_UPDATEDATA);
         p.writeInt($index);
         this.sendPackage(p);
      }
      
      public function sendGrowthPackageOpen() : void
      {
         var p:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         p.writeInt(GrowthPackageType.GROWTHPACKAGE);
         p.writeInt(GrowthPackageType.GROWTHPACKAGE_OPEN);
         this.sendPackage(p);
      }
      
      public function sendGetCSMTimeBox() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GET_CSM_BOX);
         this.sendPackage(pkg);
      }
      
      public function sendOpenDeed(type:int, playerId:int, msg:String, bool:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.KING_BLESS_MAIN);
         pkg.writeByte(type);
         pkg.writeInt(playerId);
         pkg.writeUTF(msg);
         pkg.writeBoolean(bool);
         this.sendPackage(pkg);
      }
      
      public function sendUseItemDeed(place:int, bagType:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.KING_BLESS_USE_ITEM);
         pkg.writeInt(place);
         pkg.writeInt(bagType);
         this.sendPackage(pkg);
      }
      
      public function witchBlessing_enter(num:int = 0) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WITCHBLESSING);
         pkg.writeByte(WitchBlessingPackageType.WITCHBLESSING_INFO);
         pkg.writeInt(num);
         this.sendPackage(pkg);
      }
      
      public function sendWitchBless(num:int, boo:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WITCHBLESSING);
         pkg.writeByte(WitchBlessingPackageType.WITCHBLESSING_BLESS);
         pkg.writeInt(num);
         pkg.writeBoolean(boo);
         this.sendPackage(pkg);
      }
      
      public function sendWitchGetAwards(num:int, boo:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WITCHBLESSING);
         pkg.writeByte(WitchBlessingPackageType.WITCHBLESSING_OPEN_CLOSE);
         pkg.writeInt(num);
         pkg.writeBoolean(boo);
         this.sendPackage(pkg);
      }
      
      public function treasurePuzzle_enter() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TREASUREPUZZLE);
         pkg.writeByte(TreasurePuzzlePackageType.TREASUREPUZZLE_ENTER);
         this.sendPackage(pkg);
      }
      
      public function treasurePuzzle_seeReward() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TREASUREPUZZLE);
         pkg.writeByte(TreasurePuzzlePackageType.TREASUREPUZZLE_SEE_REWARD);
         this.sendPackage(pkg);
      }
      
      public function treasurePuzzle_getReward(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TREASUREPUZZLE);
         pkg.writeByte(TreasurePuzzlePackageType.TREASUREPUZZLE_GET_REWARD);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function treasurePuzzle_savePlayerInfo(name:String, phoneNum:String, address:String, id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TREASUREPUZZLE);
         pkg.writeByte(TreasurePuzzlePackageType.TREASUREPUZZLE_SAVE_PLAYERINFO);
         pkg.writeUTF(name);
         pkg.writeUTF(phoneNum);
         pkg.writeUTF(address);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function treasurePuzzle_usePice(place:int, num:int = 1) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TREASUREPUZZLE);
         pkg.writeByte(TreasurePuzzlePackageType.TREASUREPUZZLE_USE_PICE);
         pkg.writeInt(place);
         pkg.writeInt(num);
         this.sendPackage(pkg);
      }
      
      public function halloweenInit() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(HalloweenType.ENTER);
         this.sendPackage(pkg);
      }
      
      public function sendUseEveryDayGiftRecord(templateID:int, itemID:int, index:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         pkg.writeInt(ItemActivityGiftType.ITEMACTIVITYGIFT);
         pkg.writeInt(2);
         pkg.writeInt(templateID);
         pkg.writeInt(itemID);
         pkg.writeInt(index);
         this.sendPackage(pkg);
      }
      
      public function cooking(type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FOOD_ACTIVITY);
         if(type == 1)
         {
            pkg.writeByte(FoodActivityEvent.SIMPLE_COOKING);
         }
         else
         {
            pkg.writeByte(FoodActivityEvent.PAY_COOKING);
         }
         this.sendPackage(pkg);
      }
      
      public function cookingGetAward(value:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FOOD_ACTIVITY);
         pkg.writeByte(FoodActivityEvent.REWARD);
         pkg.writeInt(value);
         this.sendPackage(pkg);
      }
      
      public function updateCookingCountByTime() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FOOD_ACTIVITY);
         pkg.writeByte(FoodActivityEvent.UPDATE_COUNT_BYTIME);
         this.sendPackage(pkg);
      }
      
      public function updateDrgnBoatBuildInfo(id:int = 0) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ESCORT);
         pkg.writeByte(DrgnBoatPackageType.BUILD_INFO);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function commitDrgnBoatMaterial(stage:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ESCORT);
         pkg.writeByte(DrgnBoatPackageType.COMMIT_MATERIAL);
         pkg.writeInt(stage);
         this.sendPackage(pkg);
      }
      
      public function helpToBuildDrgnBoat(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ESCORT);
         pkg.writeByte(DrgnBoatPackageType.HELP_TO_BUILD);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function broadcastMissileMC() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ESCORT);
         pkg.writeByte(DrgnBoatPackageType.BROADCAST_MISSILE_MC);
         this.sendPackage(pkg);
      }
      
      public function enterMagpieBridge() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MAGPIE_BRIDGE);
         pkg.writeByte(MagpieBridgePackageType.ENTER_MAGPIEBRIDGE);
         this.sendPackage(pkg);
      }
      
      public function magpieRollDice() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MAGPIE_BRIDGE);
         pkg.writeByte(MagpieBridgePackageType.ROLL_DICE);
         this.sendPackage(pkg);
      }
      
      public function buyMagpieCount(num:int, isBind:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MAGPIE_BRIDGE);
         pkg.writeByte(MagpieBridgePackageType.BUY_COUNT);
         pkg.writeInt(num);
         pkg.writeBoolean(isBind);
         this.sendPackage(pkg);
      }
      
      public function refreshMagpieView() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MAGPIE_BRIDGE);
         pkg.writeByte(MagpieBridgePackageType.REFRESH_VIEW);
         this.sendPackage(pkg);
      }
      
      public function exitMagpieView() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MAGPIE_BRIDGE);
         pkg.writeByte(MagpieBridgePackageType.EXIT_VIEW);
         this.sendPackage(pkg);
      }
      
      public function sendCryptBossFight(id:int, star:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.CRYPTBOSS);
         pkg.writeByte(CryptBossEvent.FIGHT);
         pkg.writeInt(id);
         pkg.writeInt(star);
         this.sendPackage(pkg);
      }
      
      public function requestRescueItemInfo() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.RESCUE);
         pkg.writeByte(RescueType.ITEM_INFO);
         this.sendPackage(pkg);
      }
      
      public function requestRescueFrameInfo(sceneId:int = 0) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.RESCUE);
         pkg.writeByte(RescueType.FRAME_INFO);
         pkg.writeInt(sceneId);
         this.sendPackage(pkg);
      }
      
      public function sendRescueChallenge(sceneId:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.RESCUE);
         pkg.writeByte(RescueType.CHALLENGE);
         pkg.writeInt(sceneId);
         this.sendPackage(pkg);
      }
      
      public function sendRescueCleanCD(isBind:Boolean, sceneId:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.RESCUE);
         pkg.writeByte(RescueType.CLEAN_CD);
         pkg.writeBoolean(isBind);
         pkg.writeInt(sceneId);
         this.sendPackage(pkg);
      }
      
      public function sendRescueBuyBuff(type:int, count:int, isBind:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.RESCUE);
         pkg.writeByte(RescueType.BUY_ITEM);
         pkg.writeInt(type);
         pkg.writeInt(count);
         pkg.writeBoolean(isBind);
         this.sendPackage(pkg);
      }
      
      public function useRescueKingBless() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.RESCUE_KING_BLESS);
         this.sendPackage(pkg);
      }
      
      public function getRescuePrize(sceneId:int, index:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.RESCUE);
         pkg.writeByte(RescueType.GET_PRIZE);
         pkg.writeInt(sceneId);
         pkg.writeInt(index);
         this.sendPackage(pkg);
      }
      
      public function enterOrLeaveInsectScene(flag:int, point:Point = null) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(CatchInsectPackageType.ENTER_SCENE);
         pkg.writeByte(flag);
         if(Boolean(point))
         {
            pkg.writeInt(point.x);
            pkg.writeInt(point.y);
         }
         this.sendPackage(pkg);
      }
      
      public function sendFightWithInsect(pMonsterID:int) : void
      {
         var p:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         p.writeByte(CatchInsectPackageType.FIGHT_MONSTER);
         p.writeInt(pMonsterID);
         this.sendPackage(p);
      }
      
      public function sendInsectSceneMove(endX:int, endY:int, path:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(CatchInsectPackageType.MOVE);
         pkg.writeInt(endX);
         pkg.writeInt(endY);
         pkg.writeUTF(path);
         this.sendPackage(pkg);
      }
      
      public function updateInsectInfo() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(CatchInsectPackageType.UPDATE_INFO);
         this.sendPackage(pkg);
      }
      
      public function updateInsectAreaRank() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(CatchInsectPackageType.UPDATE_AREA_RANK);
         this.sendPackage(pkg);
      }
      
      public function updateInsectAreaSelfInfo() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(CatchInsectPackageType.AREA_SELF_INFO);
         this.sendPackage(pkg);
      }
      
      public function updateInsectLocalRank() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(CatchInsectPackageType.UPDATE_LOCAL_RANK);
         this.sendPackage(pkg);
      }
      
      public function updateInsectLocalSelfInfo() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(CatchInsectPackageType.LOCAL_SELF_INFO);
         this.sendPackage(pkg);
      }
      
      public function getInsectPrize(templateId:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(CatchInsectPackageType.GET_PRIZE);
         pkg.writeInt(templateId);
         this.sendPackage(pkg);
      }
      
      public function requestCakeStatus() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(CatchInsectPackageType.CAKE_STATUS);
         this.sendPackage(pkg);
      }
      
      public function showHideTitleState(flag:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SHOW_HIDE_TITLE);
         pkg.writeBoolean(flag);
         this.sendPackage(pkg);
      }
      
      public function sendEnchant(isUpGrade:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ITEM_ENCHANT);
         pkg.writeBoolean(isUpGrade);
         this.sendPackage(pkg);
      }
      
      public function sendEnterGame() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(CloudBuyLotteryPackageType.Enter_GAME);
         this.sendPackage(pkg);
      }
      
      public function sendYGBuyGoods(num:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(CloudBuyLotteryPackageType.BUY_GOODS);
         pkg.writeInt(num);
         this.sendPackage(pkg);
      }
      
      public function sendLuckDrawGo() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(CloudBuyLotteryPackageType.GET_REWARD);
         this.sendPackage(pkg);
      }
      
      public function openMagicLib(type:int, pos:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         pkg.writeInt(MagicHousePackageType.MAGICHOUSE);
         pkg.writeInt(MagicHousePackageType.OPEN_MAGIC_LIB);
         pkg.writeInt(type);
         pkg.writeInt(pos);
         this.sendPackage(pkg);
      }
      
      public function magicLibLevelUp(type:int, count:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         pkg.writeInt(MagicHousePackageType.MAGICHOUSE);
         pkg.writeInt(MagicHousePackageType.MAGIC_LIB_LEVEL_UP);
         pkg.writeInt(type);
         pkg.writeInt(count);
         this.sendPackage(pkg);
      }
      
      public function magicLibFreeGet(count:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         pkg.writeInt(MagicHousePackageType.MAGICHOUSE);
         pkg.writeInt(MagicHousePackageType.MAGIC_LIB_FREE_GET);
         pkg.writeInt(count);
         this.sendPackage(pkg);
      }
      
      public function magicLibChargeGet(count:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         pkg.writeInt(MagicHousePackageType.MAGICHOUSE);
         pkg.writeInt(MagicHousePackageType.MAGIC_LIB_CHARGE_GET);
         pkg.writeInt(count);
         this.sendPackage(pkg);
      }
      
      public function magicOpenDepot(pos:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         pkg.writeInt(MagicHousePackageType.MAGICHOUSE);
         pkg.writeInt(MagicHousePackageType.MAGICHOUSE_OPEN_DEPOT);
         pkg.writeInt(pos);
         this.sendPackage(pkg);
      }
      
      public function enterTreasureLost() : void
      {
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("treasureLost.noWeapon"));
            return;
         }
         var pkg:PackageOut = new PackageOut(ePackageType.TREASURELOST);
         pkg.writeByte(TreasureLostPackageType.ENTERGAME);
         this.sendPackage(pkg);
      }
      
      public function treasureLostRollDice() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TREASURELOST);
         pkg.writeByte(TreasureLostPackageType.TREASURELOST_ROLLDICE);
         pkg.writeInt(1);
         this.sendPackage(pkg);
      }
      
      public function treasureLostRollGoldDice(point:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TREASURELOST);
         pkg.writeByte(TreasureLostPackageType.TREASURELOST_ROLLDICE);
         pkg.writeInt(3);
         pkg.writeInt(point);
         this.sendPackage(pkg);
      }
      
      public function treasureLostSelcetDirection(isChadao:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TREASURELOST);
         pkg.writeByte(TreasureLostPackageType.TREASURELOST_ROLLDICE);
         pkg.writeInt(2);
         pkg.writeBoolean(isChadao);
         this.sendPackage(pkg);
      }
      
      public function treasureLostMissBoss() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TREASURELOST);
         pkg.writeByte(TreasureLostPackageType.TREASURELOST_ROLLDICE);
         pkg.writeInt(4);
         this.sendPackage(pkg);
      }
      
      public function treasureLostEventDispatch(type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TREASURELOST);
         pkg.writeByte(TreasureLostPackageType.TREASURELOST_EVENT_DISPATCH);
         pkg.writeInt(type);
         this.sendPackage(pkg);
      }
      
      public function treasureLostBuyItem(type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TREASURELOST);
         pkg.writeByte(TreasureLostPackageType.TREASURELOST_BUYITEM);
         pkg.writeInt(type);
         this.sendPackage(pkg);
      }
      
      public function treasureLostExit() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TREASURELOST);
         pkg.writeByte(TreasureLostPackageType.EXITGAME);
         this.sendPackage(pkg);
      }
      
      public function eatPetsHandler(typeChoose:int, typeUse:int, count:int, petsArr:Array) : void
      {
         var i:int = 0;
         var pkg:PackageOut = new PackageOut(ePackageType.PET);
         pkg.writeByte(CrazyTankPackageType.EAT_PETS);
         pkg.writeInt(typeChoose);
         pkg.writeInt(typeUse);
         if(typeUse == 1)
         {
            pkg.writeInt(petsArr.length);
            for(i = 0; i < petsArr.length; i++)
            {
               pkg.writeInt(petsArr[i][0]);
               pkg.writeInt(petsArr[i][1].TemplateID);
            }
         }
         else
         {
            pkg.writeInt(count);
         }
         this.sendPackage(pkg);
      }
      
      public function makeNewYearRice(type:int, roomTyple:int, arr:Array) : void
      {
         var i:int = 0;
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(NewYearRicePackageType.YEARFOODCOOK);
         pkg.writeInt(type);
         pkg.writeInt(roomTyple);
         if(type != 0)
         {
            pkg.writeInt(arr.length);
            for(i = 0; i < arr.length; i++)
            {
               pkg.writeInt(arr[i].id);
               pkg.writeInt(arr[i].number);
            }
         }
         this.sendPackage(pkg);
      }
      
      public function sendCheckNewYearRiceInfo() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(NewYearRicePackageType.NEWYEARRICE_INFO);
         this.sendPackage(pkg);
      }
      
      public function sendCheckMakeNewYearFood() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(NewYearRicePackageType.YEARFOODENTER);
         this.sendPackage(pkg);
      }
      
      public function sendNewYearRiceOpen(playerNum:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(NewYearRicePackageType.YEARFOODCREATEFOOD);
         pkg.writeInt(playerNum);
         this.sendPackage(pkg);
      }
      
      public function sendExitYearFoodRoom() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(NewYearRicePackageType.YEARFOODEXITROOM);
         this.sendPackage(pkg);
      }
      
      public function sendInviteYearFoodRoom(isInvite:Boolean, playerID:int, isPublish:Boolean = false) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(NewYearRicePackageType.YEARFOODINVITE);
         pkg.writeBoolean(isInvite);
         if(!isInvite)
         {
            pkg.writeBoolean(isPublish);
         }
         pkg.writeInt(playerID);
         this.sendPackage(pkg);
      }
      
      public function sendQuitNewYearRiceRoom(playerID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(NewYearRicePackageType.YEARFOODROOMINVITE);
         pkg.writeInt(playerID);
         this.sendPackage(pkg);
      }
      
      public function sendCheckMagicStoneNumber() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MAGIC_STONE_MONSTER_INFO);
         this.sendPackage(pkg);
      }
      
      public function zodiacRolling() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         pkg.writeInt(ZodiacPackageType.ZODIAC);
         pkg.writeInt(ZodiacPackageType.ZODIAC_ROLLING);
         this.sendPackage(pkg);
      }
      
      public function zodiacGetAward(questID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         pkg.writeInt(ZodiacPackageType.ZODIAC);
         pkg.writeInt(ZodiacPackageType.ZODIAC_GETAWARD);
         pkg.writeInt(questID);
         this.sendPackage(pkg);
      }
      
      public function zodiacGetAwardAll() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         pkg.writeInt(ZodiacPackageType.ZODIAC);
         pkg.writeInt(ZodiacPackageType.ZODIAC_GETAWARDALL);
         this.sendPackage(pkg);
      }
      
      public function zodiacAddCounts() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         pkg.writeInt(ZodiacPackageType.ZODIAC);
         pkg.writeInt(ZodiacPackageType.ZODIAC_ADDCOUNT);
         this.sendPackage(pkg);
      }
      
      public function getVipAndMerryInfo(type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(ePackageType.VIP_MERRY_DISCOUNT);
         pkg.writeInt(type);
         this.sendPackage(pkg);
      }
      
      public function sendHorseRaceItemUse(gameID:int, bufftype:int, useID:int, targetID:int) : void
      {
         var nowtime:int = getTimer();
         var cd:int = nowtime - HorseRaceManager.Instance.buffCD;
         if(cd < 1000)
         {
            return;
         }
         var pkg:PackageOut = new PackageOut(ePackageType.HORSERACE);
         pkg.writeInt(gameID);
         pkg.writeInt(1);
         pkg.writeInt(bufftype);
         pkg.writeInt(useID);
         pkg.writeInt(targetID);
         pkg.writeInt(5);
         this.sendPackage(pkg);
         HorseRaceManager.Instance.buffCD = getTimer();
      }
      
      public function sendHorseRaceItemUse2(gameID:int, useId:int) : void
      {
         var nowtime:int = getTimer();
         var cd:int = nowtime - HorseRaceManager.Instance.buffCD;
         if(cd < 1000)
         {
            return;
         }
         var pkg:PackageOut = new PackageOut(ePackageType.HORSERACE);
         pkg.writeInt(gameID);
         pkg.writeInt(2);
         pkg.writeInt(useId);
         pkg.writeInt(5);
         this.sendPackage(pkg);
         HorseRaceManager.Instance.buffCD = getTimer();
      }
      
      public function sendHorseRaceEnd(gameID:int, useId:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HORSERACE);
         pkg.writeInt(gameID);
         pkg.writeInt(3);
         pkg.writeInt(useId);
         this.sendPackage(pkg);
      }
      
      public function buyHorseRaceCount() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.HORSERACE);
         pkg.writeInt(0);
         pkg.writeInt(4);
         this.sendPackage(pkg);
      }
	  
	  public function sendGuardCoreLevelUp() : void
	  {
		  var _loc1_:PackageOut = new PackageOut(ePackageType.GUARD_CORE);
		  _loc1_.writeByte(GuardCorePackageType.LEVEL_UP);
		  this.sendPackage(_loc1_);
	  }
	  
	  public function sendGuardCoreEquip(param1:int) : void
	  {
		  var _loc2_:PackageOut = new PackageOut(ePackageType.GUARD_CORE);
		  _loc2_.writeByte(GuardCorePackageType.EQUIP);
		  _loc2_.writeInt(param1);
		  this.sendPackage(_loc2_);
	  }
   }
}

