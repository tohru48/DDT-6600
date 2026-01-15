// Decompiled with JetBrains decompiler
// Type: Fighting.Server.Rooms.ProxyRoomMgr
// Assembly: Fighting.Server, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 73143BA9-1DDF-481C-AA0E-6BDD7564C4BE
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\fight\Fighting.Server.dll

using Fighting.Server.Games;
using Game.Logic;
using log4net;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

#nullable disable
namespace Fighting.Server.Rooms
{
  public class ProxyRoomMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    public static readonly int THREAD_INTERVAL = 40;
    public static readonly int PICK_UP_INTERVAL = 10000;
    public static readonly int CLEAR_ROOM_INTERVAL = 1000;
    private static bool bool_0 = false;
    private static int xXxVfttenc = 1;
    private static Queue<IAction> queue_0 = new Queue<IAction>();
    private static Thread thread_0;
    private static Dictionary<int, ProxyRoom> dictionary_0 = new Dictionary<int, ProxyRoom>();
    private static int int_0 = 0;
    private static long long_0 = 0;
    private static long long_1 = 0;

    public static bool Setup()
    {
      ProxyRoomMgr.thread_0 = new Thread(new ThreadStart(ProxyRoomMgr.smethod_0));
      return true;
    }

    public static void Start()
    {
      if (ProxyRoomMgr.bool_0)
        return;
      ProxyRoomMgr.bool_0 = true;
      ProxyRoomMgr.thread_0.Start();
    }

    public static void Stop()
    {
      if (!ProxyRoomMgr.bool_0)
        return;
      ProxyRoomMgr.bool_0 = false;
      ProxyRoomMgr.thread_0.Join();
    }

    public static void AddAction(IAction action)
    {
      lock (ProxyRoomMgr.queue_0)
        ProxyRoomMgr.queue_0.Enqueue(action);
    }

    private static void smethod_0()
    {
      long millisecondsTimeout = 0;
      ProxyRoomMgr.long_1 = TickHelper.GetTickCount();
      ProxyRoomMgr.long_0 = TickHelper.GetTickCount();
      while (ProxyRoomMgr.bool_0)
      {
        long tickCount1 = TickHelper.GetTickCount();
        try
        {
          ProxyRoomMgr.smethod_1();
          ProxyRoomMgr.smethod_5();
          if (ProxyRoomMgr.long_0 <= tickCount1)
          {
            ProxyRoomMgr.long_0 += (long) ProxyRoomMgr.PICK_UP_INTERVAL;
            ProxyRoomMgr.smethod_2(tickCount1);
          }
          if (ProxyRoomMgr.long_1 <= tickCount1)
          {
            ProxyRoomMgr.long_1 += (long) ProxyRoomMgr.CLEAR_ROOM_INTERVAL;
            ProxyRoomMgr.smethod_4(tickCount1);
          }
        }
        catch (Exception ex)
        {
          ProxyRoomMgr.ilog_0.Error((object) "Room Mgr Thread Error:", ex);
        }
        long tickCount2 = TickHelper.GetTickCount();
        millisecondsTimeout += (long) ProxyRoomMgr.THREAD_INTERVAL - (tickCount2 - tickCount1);
        if (millisecondsTimeout > 0L)
        {
          Thread.Sleep((int) millisecondsTimeout);
          millisecondsTimeout = 0L;
        }
        else if (millisecondsTimeout < -1000L)
        {
          ProxyRoomMgr.ilog_0.WarnFormat("Room Mgr is delay {0} ms!", (object) millisecondsTimeout);
          millisecondsTimeout += 1000L;
        }
      }
    }

    private static void smethod_1()
    {
      IAction[] array = (IAction[]) null;
      lock (ProxyRoomMgr.queue_0)
      {
        if (ProxyRoomMgr.queue_0.Count > 0)
        {
          array = new IAction[ProxyRoomMgr.queue_0.Count];
          ProxyRoomMgr.queue_0.CopyTo(array, 0);
          ProxyRoomMgr.queue_0.Clear();
        }
      }
      if (array == null)
        return;
      foreach (IAction action in array)
      {
        try
        {
          action.Execute();
        }
        catch (Exception ex)
        {
          ProxyRoomMgr.ilog_0.Error((object) "RoomMgr execute action error:", ex);
        }
      }
    }

    private static void smethod_2(long long_2)
    {
      List<ProxyRoom> waitMatchRoomUnsafe = ProxyRoomMgr.GetWaitMatchRoomUnsafe();
      foreach (ProxyRoom proxyRoom in waitMatchRoomUnsafe)
      {
        int num1 = 2;
        int num2 = 2;
        ProxyRoom blue1 = (ProxyRoom) null;
        if (proxyRoom.IsPlaying)
          break;
        switch (proxyRoom.RoomType)
        {
          case eRoomType.Match:
            if (proxyRoom.GameType == eGameType.Guild)
            {
              using (List<ProxyRoom>.Enumerator enumerator = waitMatchRoomUnsafe.GetEnumerator())
              {
                while (enumerator.MoveNext())
                {
                  ProxyRoom current = enumerator.Current;
                  if ((current.GuildId == 0 || current.GuildId != proxyRoom.GuildId) && current != proxyRoom && current.PlayerCount == proxyRoom.PlayerCount && !current.IsPlaying && current.GameType == eGameType.Guild && (ProxyRoomMgr.smethod_3(proxyRoom, current) < num1 || proxyRoom.PickUpCount > num2))
                    blue1 = current;
                }
                break;
              }
            }
            else if (proxyRoom.RoomType != eRoomType.RingStation)
            {
              using (List<ProxyRoom>.Enumerator enumerator = waitMatchRoomUnsafe.GetEnumerator())
              {
                while (enumerator.MoveNext())
                {
                  ProxyRoom current = enumerator.Current;
                  if (current != proxyRoom && !proxyRoom.isAutoBot && current.PlayerCount == proxyRoom.PlayerCount && !current.IsPlaying && (current.GameType == eGameType.ALL || current.GameType == eGameType.Free) && ProxyRoomMgr.smethod_3(proxyRoom, current) < num1 && proxyRoom.PickUpCount < num2 && !current.isAutoBot)
                    blue1 = current;
                }
                break;
              }
            }
            else
              break;
          case eRoomType.BattleRoom:
            using (List<ProxyRoom>.Enumerator enumerator = waitMatchRoomUnsafe.GetEnumerator())
            {
              while (enumerator.MoveNext())
              {
                ProxyRoom current = enumerator.Current;
                if (current != proxyRoom && current.RoomType == eRoomType.BattleRoom && !current.IsPlaying && current.PlayerCount == proxyRoom.PlayerCount)
                  blue1 = current;
              }
              break;
            }
          case eRoomType.Encounter:
            using (List<ProxyRoom>.Enumerator enumerator = waitMatchRoomUnsafe.GetEnumerator())
            {
              while (enumerator.MoveNext())
              {
                ProxyRoom current = enumerator.Current;
                if (current != proxyRoom && current.RoomType == eRoomType.Encounter && !current.IsPlaying && current.PlayerCount == proxyRoom.PlayerCount)
                  blue1 = current;
              }
              break;
            }
          case eRoomType.ConsortiaBattle:
            using (List<ProxyRoom>.Enumerator enumerator = waitMatchRoomUnsafe.GetEnumerator())
            {
              while (enumerator.MoveNext())
              {
                ProxyRoom current = enumerator.Current;
                if (current != proxyRoom && current.RoomType == eRoomType.ConsortiaBattle && !current.IsPlaying && current.PlayerCount == proxyRoom.PlayerCount)
                  blue1 = current;
              }
              break;
            }
          case eRoomType.SingleBattle:
            using (List<ProxyRoom>.Enumerator enumerator = waitMatchRoomUnsafe.GetEnumerator())
            {
              while (enumerator.MoveNext())
              {
                ProxyRoom current = enumerator.Current;
                if (current != proxyRoom && current.RoomType == eRoomType.SingleBattle && !current.IsPlaying && current.PlayerCount == proxyRoom.PlayerCount)
                  blue1 = current;
              }
              break;
            }
          case eRoomType.FightFootballTime:
            using (List<ProxyRoom>.Enumerator enumerator = waitMatchRoomUnsafe.GetEnumerator())
            {
              while (enumerator.MoveNext())
              {
                ProxyRoom current = enumerator.Current;
                if (current != proxyRoom && current.RoomType == eRoomType.FightFootballTime && !current.IsPlaying && current.PlayerCount == proxyRoom.PlayerCount)
                  blue1 = current;
              }
              break;
            }
        }
        if (blue1 != null)
        {
          ProxyRoomMgr.StartMatchGame(proxyRoom, blue1);
        }
        else
        {
          if (proxyRoom.PickUpCount == num2 && !proxyRoom.bool_0 && !proxyRoom.isAutoBot)
          {
            proxyRoom.bool_0 = true;
            proxyRoom.Client.SendBeginFightNpc(proxyRoom.selfId, (int) proxyRoom.RoomType, (int) proxyRoom.GameType, proxyRoom.NpcId);
            Console.WriteLine("Call AutoBot No.{0}", (object) proxyRoom.NpcId);
          }
          else if (proxyRoom.PickUpCount > num2 && proxyRoom.bool_0 && !proxyRoom.isAutoBot)
          {
            foreach (ProxyRoom blue2 in waitMatchRoomUnsafe)
            {
              if (blue2 != proxyRoom && blue2.PlayerCount == proxyRoom.PlayerCount && !blue2.IsPlaying && blue2.isAutoBot && blue2.IsFreedom && proxyRoom.NpcId == blue2.NpcId)
              {
                Console.WriteLine("Start fight with AutoBot No.{0}", (object) proxyRoom.NpcId);
                ProxyRoomMgr.StartMatchGame(proxyRoom, blue2);
              }
            }
          }
          if (!proxyRoom.isAutoBot)
          {
            ++proxyRoom.PickUpCount;
            if (num1 < 10)
            {
              int num3 = num1 + 3;
            }
          }
          else
            --proxyRoom.PickUpCount;
        }
      }
    }

    public static ProxyRoom CloneTeam(ProxyRoom red) => (ProxyRoom) null;

    private static int smethod_3(ProxyRoom proxyRoom_0, ProxyRoom proxyRoom_1)
    {
      return Math.Abs(proxyRoom_0.AvgLevel - proxyRoom_1.AvgLevel);
    }

    private static void smethod_4(long long_2)
    {
      List<ProxyRoom> proxyRoomList = new List<ProxyRoom>();
      foreach (ProxyRoom proxyRoom in ProxyRoomMgr.dictionary_0.Values)
      {
        if (!proxyRoom.IsPlaying && proxyRoom.Game != null)
          proxyRoomList.Add(proxyRoom);
      }
      foreach (ProxyRoom proxyRoom in proxyRoomList)
      {
        ProxyRoomMgr.dictionary_0.Remove(proxyRoom.RoomId);
        try
        {
          proxyRoom.Dispose();
        }
        catch (Exception ex)
        {
          ProxyRoomMgr.ilog_0.Error((object) "Room dispose error:", ex);
        }
      }
    }

    private static void smethod_5()
    {
      List<ProxyRoom> proxyRoomList = new List<ProxyRoom>();
      foreach (ProxyRoom proxyRoom in ProxyRoomMgr.dictionary_0.Values)
      {
        if (!proxyRoom.IsPlaying && proxyRoom.PickUpCount < -1)
          proxyRoomList.Add(proxyRoom);
      }
      foreach (ProxyRoom proxyRoom in proxyRoomList)
      {
        ProxyRoomMgr.dictionary_0.Remove(proxyRoom.RoomId);
        try
        {
          proxyRoom.Dispose();
        }
        catch (Exception ex)
        {
          ProxyRoomMgr.ilog_0.Error((object) "Room dispose error:", ex);
        }
      }
    }

    public static void StartMatchGame(ProxyRoom red, ProxyRoom blue)
    {
      int mapIndex = MapMgr.GetMapIndex(0, (byte) 0, ProxyRoomMgr.xXxVfttenc);
      eGameType gameType = eGameType.Free;
      eRoomType roomType = eRoomType.Match;
      if (red.GameType == blue.GameType)
      {
        gameType = red.GameType;
        roomType = red.RoomType;
      }
      if (red.RoomType == eRoomType.FightFootballTime)
        mapIndex = 1313;
      BaseGame game = (BaseGame) GameMgr.StartBattleGame(red.GetPlayers(), red, blue.GetPlayers(), blue, mapIndex, roomType, gameType, 2);
      if (game != null)
      {
        blue.StartGame(game);
        red.StartGame(game);
      }
      if (game.GameType != eGameType.Guild)
        return;
      red.Client.SendConsortiaAlly(red.GetPlayers()[0].PlayerCharacter.ConsortiaID, blue.GetPlayers()[0].PlayerCharacter.ConsortiaID, game.Id);
    }

    public static void StartWithNpcUnsafe(ProxyRoom room)
    {
      int npcId = room.NpcId;
      ProxyRoom roomUnsafe = ProxyRoomMgr.GetRoomUnsafe(room.RoomId);
      foreach (ProxyRoom blue in ProxyRoomMgr.GetWaitMatchRoomUnsafe())
      {
        if (blue.isAutoBot && !blue.IsPlaying && blue.Game == null && blue.NpcId == npcId)
        {
          Console.WriteLine("Start fight with AutoBot or VPlayer No.{0} ", (object) npcId);
          ProxyRoomMgr.StartMatchGame(roomUnsafe, blue);
        }
      }
    }

    public static bool AddRoomUnsafe(ProxyRoom room)
    {
      if (ProxyRoomMgr.dictionary_0.ContainsKey(room.RoomId))
        return false;
      ProxyRoomMgr.dictionary_0.Add(room.RoomId, room);
      return true;
    }

    public static bool RemoveRoomUnsafe(int roomId)
    {
      if (!ProxyRoomMgr.dictionary_0.ContainsKey(roomId))
        return false;
      ProxyRoomMgr.dictionary_0.Remove(roomId);
      return true;
    }

    public static ProxyRoom GetRoomUnsafe(int roomId)
    {
      return ProxyRoomMgr.dictionary_0.ContainsKey(roomId) ? ProxyRoomMgr.dictionary_0[roomId] : (ProxyRoom) null;
    }

    public static ProxyRoom[] GetAllRoom()
    {
      ProxyRoom[] allRoomUnsafe;
      lock (ProxyRoomMgr.dictionary_0)
        allRoomUnsafe = ProxyRoomMgr.GetAllRoomUnsafe();
      return allRoomUnsafe;
    }

    public static ProxyRoom[] GetAllRoomUnsafe()
    {
      ProxyRoom[] array = new ProxyRoom[ProxyRoomMgr.dictionary_0.Values.Count];
      ProxyRoomMgr.dictionary_0.Values.CopyTo(array, 0);
      return array;
    }

    public static List<ProxyRoom> GetWaitMatchRoomUnsafe()
    {
      List<ProxyRoom> waitMatchRoomUnsafe = new List<ProxyRoom>();
      foreach (ProxyRoom proxyRoom in ProxyRoomMgr.dictionary_0.Values)
      {
        if (!proxyRoom.IsPlaying && proxyRoom.Game == null)
          waitMatchRoomUnsafe.Add(proxyRoom);
      }
      return waitMatchRoomUnsafe;
    }

    public static int NextRoomId() => Interlocked.Increment(ref ProxyRoomMgr.int_0);

    public static void AddRoom(ProxyRoom room)
    {
      ProxyRoomMgr.AddAction((IAction) new AddRoomAction(room));
    }

    public static void RemoveRoom(ProxyRoom room)
    {
      ProxyRoomMgr.AddAction((IAction) new RemoveRoomAction(room));
    }
  }
}
