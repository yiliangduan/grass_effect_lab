
using UnityEditor;
using UnityEngine;


namespace YiLiang.Effect.Grass
{
    [CustomEditor(typeof(SimpleMeshCombine))]
    public class SimpleMeshCombineEditor : Editor
    {
        public override void OnInspectorGUI()
        {
            SimpleMeshCombine combiner = target as SimpleMeshCombine;

            if (null == combiner)
            {
                return;
            }

            EditorGUILayout.BeginVertical();

            if (GUILayout.Button("Combine"))
            {
                combiner.CombineMesh();
            }

            EditorGUILayout.EndVertical();

            base.OnInspectorGUI();
        }
    }
}