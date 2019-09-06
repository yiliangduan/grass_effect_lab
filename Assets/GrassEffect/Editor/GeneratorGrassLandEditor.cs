using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace YiLiang.Effect.Grass
{
    [CustomEditor(typeof(GeneratorGrassLand))]
    public class GeneratorGrassLandEditor : Editor
    {
         public override void OnInspectorGUI()
        {
            GeneratorGrassLand generator = target as GeneratorGrassLand;

            if (null == generator)
            {
                return;
            }

            EditorGUILayout.BeginVertical();

            if (GUILayout.Button("Generator"))
            {
                generator.Create();
            }

            if (GUILayout.Button("Remove"))
            {
                generator.Remove();
            }

            EditorGUILayout.EndVertical();

            base.OnInspectorGUI();
        }
    }
}