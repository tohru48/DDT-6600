// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.CNM1175
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.Actions;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class CNM1175 : AMissionControl
  {
    private List<PhysicalObj> m_bord = new List<PhysicalObj>();
    private List<PhysicalObj> m_key = new List<PhysicalObj>();
    private PhysicalObj m_door = (PhysicalObj) null;
    private string KeyIndex = (string) null;
    private int m_KeyX = -1;
    private int m_KeyY = -1;
    private int m_count = 0;

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 900)
        return 3;
      if (score > 825)
        return 2;
      return score > 725 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      this.Game.AddLoadingFile(2, "image/map/1075/objects/1075Object.swf", "game.crazytank.assetmap.Board001");
      this.Game.AddLoadingFile(2, "image/map/1075/objects/1075Object.swf", "game.crazytank.assetmap.CrystalDoor001");
      this.Game.AddLoadingFile(2, "image/map/1075/objects/1075Object.swf", "game.crazytank.assetmap.Key");
      this.Game.SetMap(1075);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.Game.TotalCount = this.Game.PlayerCount;
      this.Game.TotalTurn = this.Game.PlayerCount * 6;
      this.Game.SendMissionInfo();
      this.m_bord.Add(this.Game.CreatePhysicalObj(76, 167, "board1", "game.crazytank.assetmap.Board001", "1", 1, 336));
      this.m_bord.Add(this.Game.CreatePhysicalObj(402, 159, "board2", "game.crazytank.assetmap.Board001", "1", 1, 23));
      this.m_bord.Add(this.Game.CreatePhysicalObj(699, 156, "board3", "game.crazytank.assetmap.Board001", "1", 1, 350));
      this.m_bord.Add(this.Game.CreatePhysicalObj(959, 148, "board4", "game.crazytank.assetmap.Board001", "1", 1, 325));
      this.m_bord.Add(this.Game.CreatePhysicalObj(177, 261, "board5", "game.crazytank.assetmap.Board001", "1", 1, 22));
      this.m_bord.Add(this.Game.CreatePhysicalObj(514, 277, "board6", "game.crazytank.assetmap.Board001", "1", 1, 336));
      this.m_bord.Add(this.Game.CreatePhysicalObj(782, 285, "board7", "game.crazytank.assetmap.Board001", "1", 1, 23));
      this.m_bord.Add(this.Game.CreatePhysicalObj(1061, 280, "board8", "game.crazytank.assetmap.Board001", "1", 1, 22));
      this.m_bord.Add(this.Game.CreatePhysicalObj(273, 406, "board9", "game.crazytank.assetmap.Board001", "1", 1, 350));
      this.m_bord.Add(this.Game.CreatePhysicalObj(620, 408, "board10", "game.crazytank.assetmap.Board001", "1", 1, 23));
      this.m_bord.Add(this.Game.CreatePhysicalObj(873, 414, "board11", "game.crazytank.assetmap.Board001", "1", 1, 336));
      this.m_bord.Add(this.Game.CreatePhysicalObj(1155, 428, "board12", "game.crazytank.assetmap.Board001", "1", 1, 336));
      this.m_door = this.Game.CreatePhysicalObj(1275, 556, "door", "game.crazytank.assetmap.CrystalDoor001", "start", 1, 0);
      int[] numArray = new int[12]
      {
        12,
        12,
        12,
        12,
        12,
        12,
        12,
        12,
        12,
        12,
        12,
        12
      };
      for (int index1 = 0; index1 < this.Game.TotalCount; ++index1)
      {
        int index2 = this.Game.Random.Next(0, 12);
        if (numArray[index2] == index2)
        {
          --index1;
        }
        else
        {
          numArray[index2] = index2;
          this.m_bord.ToArray()[index2].PlayMovie("2", 0, 0);
          this.KeyIndex = string.Format("Key{0}", (object) index2);
          this.m_KeyX = this.m_bord.ToArray()[index2].X;
          this.m_KeyY = this.m_bord.ToArray()[index2].Y - 8;
          this.m_key.Add(this.Game.CreatePhysicalObj(this.m_bord.ToArray()[index2].X, this.m_bord.ToArray()[index2].Y - 8, this.KeyIndex, "game.crazytank.assetmap.Key", "1", 1, 0));
          this.Game.SendGameObjectFocus(1, this.m_bord.ToArray()[index2].Name, 0, 0);
        }
      }
      this.Game.SendGameObjectFocus(1, "door", 1000, 0);
      this.Game.SendLoadResource(new List<LoadingFileInfo>()
      {
        new LoadingFileInfo(2, "sound/Sound201.swf", "Sound201"),
        new LoadingFileInfo(2, "sound/Sound202.swf", "Sound202")
      });
      this.Game.GameOverResources.Add("game.crazytank.assetmap.CrystalDoor001");
    }

    public override void OnNewTurnStarted()
    {
      base.OnNewTurnStarted();
      if (this.Game.CurrentLiving == null)
        return;
      this.Game.CurrentLiving.Seal((Player) this.Game.CurrentLiving, 0, 0);
    }

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      if (this.Game.CurrentLiving == null)
        return;
      ((Player) this.Game.CurrentLiving).SetBall(3);
    }

    public override bool CanGameOver()
    {
      for (int index = 0; index < 12; ++index)
      {
        foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
        {
          if (allFightPlayer.X > this.m_bord[index].X - 40 && allFightPlayer.X < this.m_bord[index].X + 40 && allFightPlayer.Y < this.m_bord[index].Y && allFightPlayer.Y > this.m_bord[index].Y - 40 && this.m_bord[index].CurrentAction == "2")
          {
            this.m_bord[index].PlayMovie("3", 0, 0);
            this.KeyIndex = string.Format("Key{0}", (object) index);
            this.Game.RemovePhysicalObj(this.Game.FindPhysicalObjByName(this.KeyIndex)[0], true);
            ++this.m_count;
          }
        }
      }
      if (this.m_count == this.Game.TotalCount)
      {
        this.Game.SendGameObjectFocus(2, "door", 0, 6000);
        this.Game.SendPlaySound("201");
        this.m_door.PlayMovie("end", 4000, 3000);
        this.Game.AddAction((IAction) new PlaySoundAction("202", 10000));
        this.Game.SendUpdateUiData();
        this.Game.TurnQueue.Clear();
      }
      return this.Game.TurnIndex > this.Game.TotalTurn - 1 && this.m_count != this.Game.TotalCount || this.m_door.CurrentAction == "end";
    }

    public override int UpdateUIData() => this.m_count;

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.m_door.CurrentAction == "end")
      {
        foreach (Living allFightPlayer in this.Game.GetAllFightPlayers())
          allFightPlayer.SetSeal(false);
        this.Game.AddAllPlayerToTurn();
        this.Game.IsWin = true;
      }
      else
        this.Game.IsWin = false;
      this.Game.SendLoadResource(new List<LoadingFileInfo>()
      {
        new LoadingFileInfo(2, "image/map/show5.jpg", "")
      });
    }
  }
}
