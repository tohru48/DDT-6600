// Decompiled with JetBrains decompiler
// Type: Game.Logic.MapMgr
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Bussiness;
using Game.Logic.Phy.Maps;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading;

#nullable disable
namespace Game.Logic
{
  public class MapMgr
  {
    private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
    private static Dictionary<int, MapPoint> dictionary_0;
    private static Dictionary<int, Map> dictionary_1;
    private static Dictionary<int, List<int>> dictionary_2;
    private static ThreadSafeRandom threadSafeRandom_0;
    private static ReaderWriterLock readerWriterLock_0;

    public static int GetWeekDay
    {
      get
      {
        int int32 = Convert.ToInt32((object) DateTime.Now.DayOfWeek);
        return int32 != 0 ? int32 : 7;
      }
    }

    public static bool ReLoadMap()
    {
      try
      {
        Dictionary<int, MapPoint> maps = new Dictionary<int, MapPoint>();
        Dictionary<int, Map> mapInfos = new Dictionary<int, Map>();
        if (MapMgr.LoadMap(maps, mapInfos))
        {
          MapMgr.readerWriterLock_0.AcquireWriterLock(-1);
          try
          {
            MapMgr.dictionary_0 = maps;
            MapMgr.dictionary_1 = mapInfos;
            return true;
          }
          catch
          {
          }
          finally
          {
            MapMgr.readerWriterLock_0.ReleaseWriterLock();
          }
        }
      }
      catch (Exception ex)
      {
        if (MapMgr.ilog_0.IsErrorEnabled)
          MapMgr.ilog_0.Error((object) nameof (ReLoadMap), ex);
      }
      return false;
    }

    public static bool ReLoadMapServer()
    {
      try
      {
        Dictionary<int, List<int>> servermap = new Dictionary<int, List<int>>();
        if (MapMgr.InitServerMap(servermap))
        {
          MapMgr.readerWriterLock_0.AcquireWriterLock(-1);
          try
          {
            MapMgr.dictionary_2 = servermap;
            return true;
          }
          catch
          {
          }
          finally
          {
            MapMgr.readerWriterLock_0.ReleaseWriterLock();
          }
        }
      }
      catch (Exception ex)
      {
        if (MapMgr.ilog_0.IsErrorEnabled)
          MapMgr.ilog_0.Error((object) "ReLoadMapWeek", ex);
      }
      return false;
    }

    public static bool Init()
    {
      try
      {
        MapMgr.threadSafeRandom_0 = new ThreadSafeRandom();
        MapMgr.readerWriterLock_0 = new ReaderWriterLock();
        MapMgr.dictionary_0 = new Dictionary<int, MapPoint>();
        MapMgr.dictionary_1 = new Dictionary<int, Map>();
        if (!MapMgr.LoadMap(MapMgr.dictionary_0, MapMgr.dictionary_1))
          return false;
        MapMgr.dictionary_2 = new Dictionary<int, List<int>>();
        if (!MapMgr.InitServerMap(MapMgr.dictionary_2))
          return false;
      }
      catch (Exception ex)
      {
        if (MapMgr.ilog_0.IsErrorEnabled)
          MapMgr.ilog_0.Error((object) nameof (MapMgr), ex);
        return false;
      }
      return true;
    }

    public static bool LoadMap(Dictionary<int, MapPoint> maps, Dictionary<int, Map> mapInfos)
    {
      try
      {
        foreach (MapInfo all in new MapBussiness().GetAllMap())
        {
          if (!string.IsNullOrEmpty(all.PosX))
          {
            if (!maps.Keys.Contains<int>(all.ID))
            {
              string[] strArray1 = all.PosX.Split('|');
              string[] strArray2 = all.PosX1.Split('|');
              MapPoint mapPoint = new MapPoint();
              foreach (string str in strArray1)
              {
                if (!string.IsNullOrEmpty(str.Trim()))
                {
                  string[] strArray3 = str.Split(',');
                  mapPoint.PosX.Add(new Point(int.Parse(strArray3[0]), int.Parse(strArray3[1])));
                }
              }
              foreach (string str in strArray2)
              {
                if (!string.IsNullOrEmpty(str.Trim()))
                {
                  string[] strArray4 = str.Split(',');
                  mapPoint.PosX1.Add(new Point(int.Parse(strArray4[0]), int.Parse(strArray4[1])));
                }
              }
              maps.Add(all.ID, mapPoint);
            }
            if (!mapInfos.ContainsKey(all.ID))
            {
              Tile layer1 = (Tile) null;
              string str1 = string.Format("map\\{0}\\fore.map", (object) all.ID);
              if (File.Exists(str1))
                layer1 = new Tile(str1, true);
              Tile layer2 = (Tile) null;
              string str2 = string.Format("map\\{0}\\dead.map", (object) all.ID);
              if (File.Exists(str2))
                layer2 = new Tile(str2, false);
              if (layer1 == null && layer2 == null)
              {
                if (MapMgr.ilog_0.IsErrorEnabled)
                  MapMgr.ilog_0.Error((object) ("Map's file" + (object) all.ID + " is not exist!"));
              }
              else
                mapInfos.Add(all.ID, new Map(all, layer1, layer2));
            }
          }
        }
        if (maps.Count == 0 || mapInfos.Count == 0)
        {
          if (MapMgr.ilog_0.IsErrorEnabled)
            MapMgr.ilog_0.Error((object) ("maps:" + (object) maps.Count + ",mapInfos:" + (object) mapInfos.Count));
          return false;
        }
      }
      catch (Exception ex)
      {
        if (MapMgr.ilog_0.IsErrorEnabled)
          MapMgr.ilog_0.Error((object) nameof (MapMgr), ex);
        return false;
      }
      return true;
    }

    public static Map CloneMap(int index)
    {
      return MapMgr.dictionary_1.ContainsKey(index) ? MapMgr.dictionary_1[index].Clone() : (Map) null;
    }

    public static MapInfo FindMapInfo(int index)
    {
      return MapMgr.dictionary_1.ContainsKey(index) ? MapMgr.dictionary_1[index].Info : (MapInfo) null;
    }

    public static int GetMapIndex(int index, byte type, int serverId)
    {
      if (index != 0 && !MapMgr.dictionary_0.Keys.Contains<int>(index))
        index = 0;
      if (index != 0)
        return index;
      if (serverId > MapMgr.dictionary_2.Count)
        serverId = MapMgr.dictionary_2.Count - 1;
      List<int> intList = new List<int>();
      foreach (int index1 in MapMgr.dictionary_2[serverId])
      {
        MapInfo mapInfo = MapMgr.FindMapInfo(index1);
        if (((int) type & (int) mapInfo.Type) != 0)
          intList.Add(index1);
      }
      if (intList.Count == 0)
      {
        int count = MapMgr.dictionary_2[serverId].Count;
        return MapMgr.dictionary_2[serverId][MapMgr.threadSafeRandom_0.Next(count)];
      }
      int count1 = intList.Count;
      return intList[MapMgr.threadSafeRandom_0.Next(count1)];
    }

    public static MapPoint GetMapRandomPos(int index)
    {
      MapPoint mapRandomPos = new MapPoint();
      if (index != 0 && !MapMgr.dictionary_0.Keys.Contains<int>(index))
        index = 0;
      MapPoint mapPoint;
      if (index == 0)
      {
        int[] array = MapMgr.dictionary_0.Keys.ToArray<int>();
        mapPoint = MapMgr.dictionary_0[array[MapMgr.threadSafeRandom_0.Next(array.Length)]];
      }
      else
        mapPoint = MapMgr.dictionary_0[index];
      if (MapMgr.threadSafeRandom_0.Next(2) == 1)
      {
        mapRandomPos.PosX.AddRange((IEnumerable<Point>) mapPoint.PosX);
        mapRandomPos.PosX1.AddRange((IEnumerable<Point>) mapPoint.PosX1);
      }
      else
      {
        mapRandomPos.PosX.AddRange((IEnumerable<Point>) mapPoint.PosX1);
        mapRandomPos.PosX1.AddRange((IEnumerable<Point>) mapPoint.PosX);
      }
      return mapRandomPos;
    }

    public static MapPoint GetPVEMapRandomPos(int index)
    {
      MapPoint pveMapRandomPos = new MapPoint();
      if (index != 0 && !MapMgr.dictionary_0.Keys.Contains<int>(index))
        index = 0;
      MapPoint mapPoint;
      if (index == 0)
      {
        int[] array = MapMgr.dictionary_0.Keys.ToArray<int>();
        mapPoint = MapMgr.dictionary_0[array[MapMgr.threadSafeRandom_0.Next(array.Length)]];
      }
      else
        mapPoint = MapMgr.dictionary_0[index];
      pveMapRandomPos.PosX.AddRange((IEnumerable<Point>) mapPoint.PosX);
      pveMapRandomPos.PosX1.AddRange((IEnumerable<Point>) mapPoint.PosX1);
      return pveMapRandomPos;
    }

    public static bool InitServerMap(Dictionary<int, List<int>> servermap)
    {
      ServerMapInfo[] allServerMap = new MapBussiness().GetAllServerMap();
      try
      {
        int result = 0;
        foreach (ServerMapInfo serverMapInfo in allServerMap)
        {
          if (!servermap.Keys.Contains<int>(serverMapInfo.ServerID))
          {
            string[] strArray = serverMapInfo.OpenMap.Split(',');
            List<int> intList = new List<int>();
            foreach (string s in strArray)
            {
              if (!string.IsNullOrEmpty(s) && int.TryParse(s, out result))
                intList.Add(result);
            }
            servermap.Add(serverMapInfo.ServerID, intList);
          }
        }
      }
      catch (Exception ex)
      {
        MapMgr.ilog_0.Error((object) ex.ToString());
      }
      return true;
    }
  }
}
