// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Game.Labyrinth1
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;

#nullable disable
namespace GameServerScript.AI.Game
{
  public class Labyrinth1 : APVEGameControl
  {
    public override void OnCreated()
    {
      string missionIds = "40001,40002,40003,40004,40005,40006,40007,40008,40009,40010" + ",40011,40012,40013,40014,40015,40016,40017,40018,40019,40020" + ",40021,40022,40023,40024,40025,40026,40027,40028,40029,40030" + ",40031,40032,40033,40034,40035,40036,40037,40038,40039,40040";
      this.Game.SetupMissions(missionIds);
      this.Game.TotalMissionCount = missionIds.Split(',').Length;
    }

    public override void OnPrepated()
    {
    }

    public override int CalculateScoreGrade(int score)
    {
      if (score > 800)
        return 3;
      if (score > 725)
        return 2;
      return score > 650 ? 1 : 0;
    }

    public override void OnGameOverAllSession()
    {
    }
  }
}
