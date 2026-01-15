package ddt.manager
{
   import ddt.data.socket.CrazyTankPackageType;
   import ddt.data.socket.GameRoomPackageType;
   import ddt.data.socket.GypsyShopPackageType;
   import ddt.data.socket.WorshipTheMoonPackageType;
   import ddt.data.socket.ePackageType;
   import flash.geom.Point;
   import kingDivision.data.KingDivisionPackageType;
   import pyramid.PyramidPackageType;
   import road7th.comm.ByteSocket;
   import road7th.comm.PackageOut;
   import room.transnational.TransnationalPackageType;
   
   public class GameInSocketOut
   {
      
      private static var _socket:ByteSocket = SocketManager.Instance.socket;
      
      public function GameInSocketOut()
      {
         super();
      }
      
      public static function sendGetScenePlayer(index:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SCENE_USERS_LIST);
         pkg.writeByte(index);
         pkg.writeByte(6);
         sendPackage(pkg);
      }
      
      public static function sendInviteGame(playerid:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_INVITE);
         pkg.writeInt(playerid);
         sendPackage(pkg);
      }
      
      public static function sendBuyProp(id:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PROP_BUY);
         pkg.writeInt(id);
         sendPackage(pkg);
      }
      
      public static function sendSellProp(id:int, GoodsID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.PROP_SELL);
         pkg.writeInt(id);
         pkg.writeInt(GoodsID);
         sendPackage(pkg);
      }
      
      public static function sendGameRoomSetUp(id:int, type:int, isOpenBoss:Boolean = false, pass:String = "", name:String = "", secondType:int = 2, permission:int = 0, levelLimits:int = 0, allowCrossZone:Boolean = false, tempID:int = 0) : void
      {
         var secType:int = PlayerManager.Instance.Self.Grade < 5 ? 4 : secondType;
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.GAME_ROOM_SETUP_CHANGE);
         pkg.writeInt(id);
         pkg.writeByte(type);
         pkg.writeBoolean(isOpenBoss);
         pkg.writeUTF(pass);
         pkg.writeUTF(name);
         pkg.writeByte(secType);
         pkg.writeByte(permission);
         pkg.writeInt(levelLimits);
         pkg.writeBoolean(allowCrossZone);
         pkg.writeInt(tempID);
         sendPackage(pkg);
      }
      
      public static function sendCreateRoom(name:String, roomType:int, timeType:int = 2, pass:String = "", isDouble:Boolean = false) : void
      {
         var secType:int = PlayerManager.Instance.Self.Grade < 5 ? 4 : timeType;
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.GAME_ROOM_CREATE);
         pkg.writeByte(roomType);
         pkg.writeByte(secType);
         pkg.writeUTF(name);
         pkg.writeUTF(pass);
         pkg.writeBoolean(isDouble);
         sendPackage(pkg);
      }
      
      public static function sendGameRoomPlaceState(index:int, isOpened:int, toNewPlace:Boolean = false, _newPlace:int = -100) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.GAME_ROOM_UPDATE_PLACE);
         pkg.writeByte(index);
         pkg.writeInt(isOpened);
         pkg.writeBoolean(toNewPlace);
         pkg.writeInt(_newPlace);
         sendPackage(pkg);
      }
      
      public static function sendGameRoomKick(index:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.GAME_ROOM_KICK);
         pkg.writeByte(index);
         sendPackage(pkg);
      }
      
      public static function sendExitScene() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.SCENE_REMOVE_USER);
         sendPackage(pkg);
      }
      
      public static function sendGamePlayerExit() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.GAME_ROOM_REMOVEPLAYER);
         sendPackage(pkg);
      }
      
      public static function sendGameTeam(team:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.GAME_TEAM);
         pkg.writeByte(team);
         sendPackage(pkg);
      }
      
      public static function sendFlagMode(flag:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.WANNA_LEADER);
         pkg.writeBoolean(flag);
         sendPackage(pkg);
      }
      
      public static function sendGameStart() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.GAME_START);
         sendPackage(pkg);
      }
      
      public static function sendGameMissionStart(isStart:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_MISSION_START);
         pkg.writeBoolean(isStart);
         sendPackage(pkg);
      }
      
      public static function sendGameMissionPrepare(place:int, isRead:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.GAME_MISSION_PREPARE);
         pkg.writeBoolean(isRead);
         sendPackage(pkg);
      }
      
      public static function sendLoadingProgress(progress:Number) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.LOAD);
         pkg.writeInt(progress);
         sendPackage(pkg);
      }
      
      public static function sendPlayerState(ready:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.GAME_PLAYER_STATE_CHANGE);
         pkg.writeByte(ready);
         sendPackage(pkg);
      }
      
      public static function sendStartOrPreCheckEnergy() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.GAME_ENERGY_NOT_ENOUGH);
         sendPackage(pkg);
      }
      
      public static function sendGameCMDBlast(id:int, x:int, y:int, t:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.BLAST);
         pkg.writeInt(id);
         pkg.writeInt(x);
         pkg.writeInt(y);
         pkg.writeInt(t);
         sendPackage(pkg);
      }
      
      public static function sendGameCMDChange(id:int, bombPosX:int, bombPosY:int, vx:int, vy:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.CHANGEBALL);
         pkg.writeInt(id);
         pkg.writeInt(bombPosX);
         pkg.writeInt(bombPosY);
         pkg.writeInt(vx);
         pkg.writeInt(vy);
         sendPackage(pkg);
      }
      
      public static function sendGameCMDDirection(direction:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.DIRECTION);
         pkg.writeInt(direction);
         sendPackage(pkg);
      }
      
      public static function sendGameCMDStunt(skillId:int = 0) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.STUNT);
         pkg.writeByte(skillId);
         sendPackage(pkg);
      }
      
      public static function sendGameCMDShoot(x:int, y:int, force:int, angle:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.FIRE);
         pkg.writeInt(int(x));
         pkg.writeInt(int(y));
         pkg.writeInt(int(force));
         pkg.writeInt(int(angle));
         sendPackage(pkg);
      }
      
      public static function sendGameSkipNext(time:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.SKIPNEXT);
         pkg.writeByte(time);
         sendPackage(pkg);
      }
      
      public static function sendTransmissionGate(value:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.DELIVER);
         pkg.writeBoolean(value);
         sendPackage(pkg);
      }
      
      public static function sendGameStartMove(type:Number, x:int, y:int, dir:Number, isLiving:Boolean, turnIndex:Number) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.MOVESTART);
         pkg.writeBoolean(true);
         pkg.writeByte(type);
         pkg.writeInt(x);
         pkg.writeInt(y);
         pkg.writeByte(dir);
         pkg.writeBoolean(isLiving);
         pkg.writeShort(turnIndex);
         sendPackage(pkg);
      }
      
      public static function sendGameStopMove(posX:int, posY:int, isUser:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.MOVESTOP);
         pkg.writeInt(posX);
         pkg.writeInt(posY);
         pkg.writeBoolean(isUser);
         sendPackage(pkg);
      }
      
      public static function sendGameTakeOut(place:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.TAKE_CARD);
         pkg.writeByte(place);
         sendPackage(pkg);
      }
      
      public static function sendFightFootballTimeTakeOut(place:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.FIGHTFOOTBALLTIMETAKEOUT);
         pkg.writeByte(place);
         sendPackage(pkg);
      }
      
      public static function sendBossTakeOut(place:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.BOSS_TAKE_CARD);
         pkg.writeByte(place);
         sendPackage(pkg);
      }
      
      public static function sendGetTropToBag(place:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_TAKE_TEMP);
         pkg.writeInt(place);
         sendPackage(pkg);
      }
      
      public static function sendShootTag(b:Boolean, time:int = 0) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.FIRE_TAG);
         pkg.writeBoolean(b);
         if(b)
         {
            pkg.writeByte(time);
         }
         sendPackage(pkg);
      }
      
      public static function sendBeat(x:Number, y:Number, angle:Number) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.BEAT);
         pkg.writeShort(x);
         pkg.writeShort(y);
         pkg.writeShort(angle);
         sendPackage(pkg);
      }
      
      public static function sendThrowProp(place:int) : void
      {
         var pkg:PackageOut = new PackageOut(CrazyTankPackageType.PROP_DELETE);
         pkg.writeInt(place);
         sendPackage(pkg);
      }
      
      public static function sendUseProp(type:int, place:int, tempid:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.PROP);
         pkg.writeByte(type);
         pkg.writeInt(place);
         pkg.writeInt(tempid);
         sendPackage(pkg);
      }
      
      public static function sendCancelWait() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.GAME_PICKUP_CANCEL);
         sendPackage(pkg);
      }
      
      public static function sendSingleRoomBegin(type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.SINGLE_ROOM_BEGIN);
         pkg.writeInt(type);
         sendPackage(pkg);
      }
      
      public static function sendTransnationalBegin(type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TRANSNATIONALFIGHT_ACTIVED);
         pkg.writeByte(type);
         sendPackage(pkg);
      }
      
      public static function revertPlayerInfo(type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TRANSNATIONALFIGHT_ACTIVED);
         pkg.writeByte(type);
         sendPackage(pkg);
      }
      
      public static function sendEquipmentTransnational(tempID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.TRANSNATIONALFIGHT_ACTIVED);
         pkg.writeByte(TransnationalPackageType.MOVE_EQUIPMENT);
         pkg.writeInt(tempID);
         sendPackage(pkg);
      }
      
      public static function sendGameStyle(style:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         pkg.writeInt(GameRoomPackageType.GAME_PICKUP_STYLE);
         pkg.writeInt(style);
         sendPackage(pkg);
      }
      
      public static function sendGhostTarget(pos:Point) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.GHOST_TARGET);
         pkg.writeInt(pos.x);
         pkg.writeInt(pos.y);
         sendPackage(pkg);
      }
      
      public static function sendPaymentTakeCard(place:int, bool:Boolean = true) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.PAYMENT_TAKE_CARD);
         pkg.writeByte(place);
         pkg.writeBoolean(bool);
         sendPackage(pkg);
      }
      
      public static function sendMissionTryAgain(tryAgain:int, isHost:Boolean, bool:Boolean = true) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.GAME_MISSION_TRY_AGAIN);
         pkg.writeInt(tryAgain);
         pkg.writeBoolean(isHost);
         pkg.writeBoolean(bool);
         sendPackage(pkg);
      }
      
      public static function sendFightLibInfoChange(id:int, difficult:int = -1) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.FIGHT_LIB_INFO_CHANGE);
         pkg.writeInt(id);
         pkg.writeInt(difficult);
         sendPackage(pkg);
      }
      
      public static function sendPassStory() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.PASS_STORY);
         pkg.writeBoolean(true);
         sendPackage(pkg);
      }
      
      public static function sendClientScriptStart() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         pkg.writeInt(3);
         sendPackage(pkg);
      }
      
      public static function sendClientScriptEnd() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         pkg.writeInt(2);
         sendPackage(pkg);
      }
      
      public static function sendFightLibAnswer(questionID:int, answerID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         pkg.writeInt(4);
         pkg.writeInt(questionID);
         pkg.writeInt(answerID);
         sendPackage(pkg);
      }
      
      public static function sendFightLibReanswer() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         pkg.writeInt(5);
         sendPackage(pkg);
      }
      
      public static function sendUpdatePlayStep(cmd:String) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.MISSION_CMD);
         pkg.writeInt(6);
         pkg.writeUTF(cmd);
         sendPackage(pkg);
      }
      
      public static function sendSelectObject(id:int, zoneID:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         pkg.writeByte(CrazyTankPackageType.SELECT_OBJECT);
         pkg.writeInt(id);
         pkg.writeInt(zoneID);
         sendPackage(pkg);
      }
      
      private static function sendPackage(pkg:PackageOut) : void
      {
         _socket.send(pkg);
      }
      
      public static function sendDiceRefreshData() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.DICE_SYSTEM);
         pkg.writeByte(12);
         sendPackage(pkg);
      }
      
      public static function sendStartDiceInfo(type:int, position:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.DICE_SYSTEM);
         pkg.writeByte(11);
         pkg.writeInt(type);
         pkg.writeInt(position);
         sendPackage(pkg);
      }
      
      public static function sendRequestEnterDiceSystem() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.DICE_SYSTEM);
         pkg.writeByte(10);
         sendPackage(pkg);
      }
      
      public static function sendRequestEnterPyramidSystem() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(PyramidPackageType.PYRAMID_ENTER);
         sendPackage(pkg);
      }
      
      public static function sendPyramidStartOrstop(isStart:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(PyramidPackageType.PYRAMID_STARTORSTOP);
         pkg.writeBoolean(isStart);
         sendPackage(pkg);
      }
      
      public static function sendPyramidTurnCard(layer:int, position:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(PyramidPackageType.PYRAMID_RESULT);
         pkg.writeInt(layer);
         pkg.writeInt(position);
         sendPackage(pkg);
      }
      
      public static function sendPyramidRevive(isRevive:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         pkg.writeByte(PyramidPackageType.PYRAMID_DIEEVENT);
         pkg.writeBoolean(isRevive);
         sendPackage(pkg);
      }
      
      public static function sendKingDivisionGameStart(type:int) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.KING_DIVISION);
         pkg.writeByte(type);
         sendPackage(pkg);
      }
      
      public static function sendGetConsortionMessageThisZone() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.KING_DIVISION);
         pkg.writeByte(KingDivisionPackageType.CONSORTIA_MATCH_SCORE);
         sendPackage(pkg);
      }
      
      public static function sendGetConsortionMessageAllZone() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.KING_DIVISION);
         pkg.writeByte(KingDivisionPackageType.CONSORTIA_MATCH_AREA_RANK);
         sendPackage(pkg);
      }
      
      public static function sendGetEliminateConsortionMessageThisZone() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.KING_DIVISION);
         pkg.writeByte(KingDivisionPackageType.CONSORTIA_MATCH_RANK);
         sendPackage(pkg);
      }
      
      public static function sendGetEliminateConsortionMessageAllZone() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.KING_DIVISION);
         pkg.writeByte(KingDivisionPackageType.CONSORTIA_MATCH_AREA_RANK_INFO);
         sendPackage(pkg);
      }
      
      public static function sendWorshipTheMoon(counts:int, isBindTickets:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WORSHIP_THE_MOON_MID_AUTUMN);
         pkg.writeByte(WorshipTheMoonPackageType.WORSHIP_THE_MOON);
         pkg.writeInt(counts);
         pkg.writeBoolean(isBindTickets);
         sendPackage(pkg);
      }
      
      public static function sendWorshipTheMoonIsActivityOpen() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WORSHIP_THE_MOON_MID_AUTUMN);
         pkg.writeByte(WorshipTheMoonPackageType.IS_ACTIVITY_OPEN);
         sendPackage(pkg);
      }
      
      public static function sendWorshipTheMoonFreeCount() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WORSHIP_THE_MOON_MID_AUTUMN);
         pkg.writeByte(WorshipTheMoonPackageType.FREE_COUNT);
         sendPackage(pkg);
      }
      
      public static function sendWorshipTheMoonAwardsList() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WORSHIP_THE_MOON_MID_AUTUMN);
         pkg.writeByte(WorshipTheMoonPackageType.AWARDS_LIST);
         sendPackage(pkg);
      }
      
      public static function sendGainThe200timesAwardBox() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.WORSHIP_THE_MOON_MID_AUTUMN);
         pkg.writeByte(WorshipTheMoonPackageType.RECEIVE_MOON_REWARD);
         sendPackage(pkg);
      }
      
      public static function sendFightFootballTimeBegin(type:int) : void
      {
      }
      
      public static function sendGypsyBuy(id:int, isBind:Boolean) : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MYSTERY_SHOP);
         pkg.writeByte(GypsyShopPackageType.BUY);
         pkg.writeInt(id);
         pkg.writeBoolean(isBind);
         sendPackage(pkg);
      }
      
      public static function sendGypsyRefreshItemList() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MYSTERY_SHOP);
         pkg.writeByte(GypsyShopPackageType.PLAYER_INFO);
         sendPackage(pkg);
      }
      
      public static function sendGypsyManualRefreshItemList() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MYSTERY_SHOP);
         pkg.writeByte(GypsyShopPackageType.REFRESH);
         sendPackage(pkg);
      }
      
      public static function sendGypsyRefreshRareList() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MYSTERY_SHOP);
         pkg.writeByte(GypsyShopPackageType.RARE_ITEM_INFO);
         sendPackage(pkg);
      }
      
      public static function sendRequestGypsyNPCState() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.MYSTERY_SHOP);
         pkg.writeByte(GypsyShopPackageType.OPEN_INFO);
         sendPackage(pkg);
      }
      
      public static function sendCalendarPet() : void
      {
         var pkg:PackageOut = new PackageOut(ePackageType.DAILY_AWARD);
         pkg.writeInt(11);
         sendPackage(pkg);
      }
   }
}

