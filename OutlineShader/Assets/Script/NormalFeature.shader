Shader "Custom/NormalFeature" {
	Properties{
		_LineTex ("Line Texture", 2D) = "defaulttexture" {}
		_Outline ("Outline Color", Color) = (0,0,0,0)
		_Fuzziness ("Fuzziness", Float) = 0.05
	}
	SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 200
		Pass {
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f{
				half3 worldNormal : NORMAL;
				float2 uv: TEXCOORD0;
				float4 screenPos: TEXCOORD1;
				float4 pos : SV_POSITION;
			};

			fixed4 _LightColor;

			v2f vert (float4 vertex : POSITION, half3 normal : NORMAL, float2 uv : TEXCOORD0, fixed4 diff: COLOR0, float4 screenPos : TEXCOORD1){
				v2f o;
				o.pos = mul (UNITY_MATRIX_MVP, vertex);
				o.worldNormal = mul (UNITY_MATRIX_IT_MV, normal);
				o.uv = uv;
				half nl = dot(normal,normalize(ObjSpaceLightDir(vertex)));
				o.screenPos = ComputeScreenPos(o.pos);
				return o;
			}

			fixed4 _Outline;
			float _Fuzziness;
			sampler2D _LineTex;

			fixed4 frag (v2f i) : SV_Target {
				fixed difference = ddx(i.worldNormal.b) - i.worldNormal.b;
				fixed nSqr = -(difference * difference) + _Fuzziness;
				clip (nSqr);
				fixed4 color = tex2D(_LineTex, i.screenPos) * _Outline;
				return color;
			}
			ENDCG
		}
	} 
}
