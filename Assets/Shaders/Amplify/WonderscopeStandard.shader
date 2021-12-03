// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WSStandard"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		[Toggle]_TintwithVertexColor("Tint with Vertex Color", Range( 0 , 1)) = 0
		_BumpMap("Normal", 2D) = "bump" {}
		[Toggle]_UseMODSTexture("Use MODS Texture", Range( 0 , 1)) = 1
		_MetallicGlossMap("Metallic", 2D) = "black" {}
		_Tint("Tint", Color) = (1,1,1,1)
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Glossiness("Glossiness", Range( 0 , 1)) = 0.1
		_GlossMapScale("GlossMapScale", Range( 0 , 1)) = 1
		[Toggle]_AffectedBySnow("AffectedBySnow", Range( 0 , 1)) = 1
		_SnowNormalPower("SnowNormalPower", Range( 0 , 20)) = 1
		_EmissiveTex("EmissiveTex", 2D) = "black" {}
		[HDR]_Emissive("Emissive", Color) = (0,0,0,0)
		_SnowIntensityMultiplier("SnowIntensityMultiplier", Range( 0 , 5)) = 1.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Tint;
		uniform sampler2D _GlobalSnowTexture;
		uniform float4 _GlobalSnowTextureTiling;
		uniform float _SnowNormalPower;
		uniform float _SnowIntensityMultiplier;
		uniform float _GlobalSnowAmount;
		uniform float _AffectedBySnow;
		uniform float _TintwithVertexColor;
		uniform sampler2D _EmissiveTex;
		uniform float4 _EmissiveTex_ST;
		uniform float4 _Emissive;
		uniform float _Metallic;
		uniform float _Glossiness;
		uniform sampler2D _MetallicGlossMap;
		uniform float4 _MetallicGlossMap_ST;
		uniform float _GlossMapScale;
		uniform float _UseMODSTexture;
		uniform float _GlobalSnowSmoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float3 normal75 = UnpackNormal( tex2D( _BumpMap, uv_BumpMap ) );
			o.Normal = normal75;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult17_g1 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 appendResult24_g1 = (float2(_GlobalSnowTextureTiling.x , _GlobalSnowTextureTiling.y));
			float4 tex2DNode3_g1 = tex2D( _GlobalSnowTexture, ( appendResult17_g1 * appendResult24_g1 ) );
			float4 snowAlbedo92 = tex2DNode3_g1;
			float snowTexAlpha6_g1 = tex2DNode3_g1.a;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float dotResult4_g1 = dot( ase_normWorldNormal , float3(0,1,0) );
			float temp_output_8_0_g1 = pow( saturate( dotResult4_g1 ) , _SnowNormalPower );
			float temp_output_26_0_g1 = _SnowIntensityMultiplier;
			float lerpResult12_g1 = lerp( ( snowTexAlpha6_g1 * temp_output_8_0_g1 * temp_output_26_0_g1 ) , 1.0 , temp_output_8_0_g1);
			float snowAmount73 = ( saturate( ( lerpResult12_g1 * temp_output_26_0_g1 * _GlobalSnowAmount ) ) * _AffectedBySnow );
			float4 lerpResult60 = lerp( ( tex2D( _MainTex, uv_MainTex ) * _Tint ) , snowAlbedo92 , snowAmount73);
			float4 color124 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
			float4 lerpResult125 = lerp( color124 , i.vertexColor , _TintwithVertexColor);
			float4 albedo122 = ( lerpResult60 * lerpResult125 );
			o.Albedo = albedo122.rgb;
			float2 uv_EmissiveTex = i.uv_texcoord * _EmissiveTex_ST.xy + _EmissiveTex_ST.zw;
			float4 emissive120 = ( tex2D( _EmissiveTex, uv_EmissiveTex ) * _Emissive );
			o.Emission = emissive120.rgb;
			float4 appendResult99 = (float4(_Metallic , 1.0 , 0.0 , _Glossiness));
			float2 uv_MetallicGlossMap = i.uv_texcoord * _MetallicGlossMap_ST.xy + _MetallicGlossMap_ST.zw;
			float4 appendResult114 = (float4(1.0 , 1.0 , 1.0 , _GlossMapScale));
			float4 lerpResult96 = lerp( appendResult99 , ( tex2D( _MetallicGlossMap, uv_MetallicGlossMap ) * appendResult114 ) , _UseMODSTexture);
			float4 break43 = lerpResult96;
			float lerpResult80 = lerp( break43.r , 0.0 , snowAmount73);
			float metallic132 = lerpResult80;
			o.Metallic = metallic132;
			float lerpResult77 = lerp( break43.a , _GlobalSnowSmoothness , snowAmount73);
			float smoothness130 = lerpResult77;
			o.Smoothness = smoothness130;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
-1927;152;1873;1019;-1910.051;-490.7156;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;136;1412.664,211.9822;Inherit;False;1355.524;373.5729;Normal;8;106;103;111;104;20;92;75;73;Normal & Snow;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;137;1404.634,739.9933;Inherit;False;1847.06;795.0416;Metallic;18;115;100;114;38;101;99;112;94;96;43;82;79;78;80;77;83;130;132;Metallic Roughness;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;106;1723.42,261.9821;Inherit;False;Property;_SnowIntensityMultiplier;SnowIntensityMultiplier;15;0;Create;True;0;0;0;False;0;False;1.5;1.5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;1476.547,1236.538;Inherit;False;Property;_GlossMapScale;GlossMapScale;8;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;111;2049.204,361.6329;Inherit;False;GetSnow;10;;1;a6b677fe4d0605d46bde1ae86a5ea4db;0;1;26;FLOAT;1.5;False;2;COLOR;22;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;2032.252,470.1551;Inherit;False;Property;_AffectedBySnow;AffectedBySnow;9;1;[Toggle];Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;2378.252,439.1551;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;1565.855,922.1954;Inherit;False;Property;_Glossiness;Glossiness;7;0;Create;True;0;0;0;False;0;False;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;134;1417.199,-974.1166;Inherit;False;1705.024;1016.258;Albedo;12;74;60;124;125;126;49;93;50;1;127;129;122;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;114;1866.414,1124.825;Inherit;False;FLOAT4;4;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;38;1454.634,1037.899;Inherit;True;Property;_MetallicGlossMap;Metallic;4;0;Create;False;0;0;0;True;0;False;-1;None;0131285cfd6970a418bd49b360daa05a;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;100;1565.855,833.1954;Inherit;False;Property;_Metallic;Metallic;6;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;2421.309,283.3209;Inherit;False;snowAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;1467.199,-924.1166;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;True;0;False;-1;None;2aa705f5b35ea124cb46105899cb41fb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;50;1553.79,-700.7939;Inherit;False;Property;_Tint;Tint;5;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;99;1902.855,840.1954;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;94;1723.782,1347.524;Inherit;False;Property;_UseMODSTexture;Use MODS Texture;3;1;[Toggle];Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;2032.813,1040.325;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;2543.388,378.9612;Inherit;False;snowAmount;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;135;1408.176,1711.301;Inherit;False;941.478;517.629;Emissive;4;119;116;118;120;Emissive;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;1843.847,-596.0134;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;126;2217.9,-253.6713;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;96;2231.354,1016.495;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;1789.303,-376.7426;Inherit;False;73;snowAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;1797.266,-492.7531;Inherit;False;92;snowAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;127;2112.068,-73.25892;Inherit;False;Property;_TintwithVertexColor;Tint with Vertex Color;1;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;124;2175.381,-437.3497;Inherit;False;Constant;_Color0;Color 0;13;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;79;2387.481,1419.635;Inherit;False;73;snowAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;43;2561.241,1029.214;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SamplerNode;119;1458.176,1761.301;Inherit;True;Property;_EmissiveTex;EmissiveTex;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;82;2497.672,864.5645;Inherit;False;73;snowAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;116;1510.671,2019.93;Inherit;False;Property;_Emissive;Emissive;14;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;78;2311.081,1326.736;Inherit;False;Global;_GlobalSnowSmoothness;_GlobalSnowSmoothness;6;0;Create;True;0;0;0;False;0;False;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;60;2122.685,-562.1851;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;125;2532.534,-432.2476;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;80;2745.672,798.2643;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;77;2795.481,1300.335;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;1827.295,1945.762;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;20;1462.664,351.9941;Inherit;True;Property;_BumpMap;Normal;2;0;Create;False;0;0;0;True;0;False;-1;None;bef301e9999f58a40b972ae9c383fb8a;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;2740.058,-562.9406;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;3006.199,810.9933;Inherit;False;metallic;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;1800.067,357.0699;Inherit;False;normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;130;3026.894,1292.197;Inherit;False;smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;2124.854,1926.596;Inherit;False;emissive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;2900.023,-568.1404;Inherit;False;albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;3697.494,362.455;Inherit;False;122;albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;3674.54,755.8583;Inherit;False;130;smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;3704.427,445.8531;Inherit;False;75;normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;3702.596,524.0239;Inherit;False;120;emissive;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;3696.957,657.072;Inherit;False;132;metallic;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;2868.835,962.735;Inherit;False;occlusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4017.811,452.8008;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;WSStandard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;111;26;106;0
WireConnection;104;0;111;0
WireConnection;104;1;103;0
WireConnection;114;3;115;0
WireConnection;92;0;111;22
WireConnection;99;0;100;0
WireConnection;99;3;101;0
WireConnection;112;0;38;0
WireConnection;112;1;114;0
WireConnection;73;0;104;0
WireConnection;49;0;1;0
WireConnection;49;1;50;0
WireConnection;96;0;99;0
WireConnection;96;1;112;0
WireConnection;96;2;94;0
WireConnection;43;0;96;0
WireConnection;60;0;49;0
WireConnection;60;1;93;0
WireConnection;60;2;74;0
WireConnection;125;0;124;0
WireConnection;125;1;126;0
WireConnection;125;2;127;0
WireConnection;80;0;43;0
WireConnection;80;2;82;0
WireConnection;77;0;43;3
WireConnection;77;1;78;0
WireConnection;77;2;79;0
WireConnection;118;0;119;0
WireConnection;118;1;116;0
WireConnection;129;0;60;0
WireConnection;129;1;125;0
WireConnection;132;0;80;0
WireConnection;75;0;20;0
WireConnection;130;0;77;0
WireConnection;120;0;118;0
WireConnection;122;0;129;0
WireConnection;83;0;43;1
WireConnection;0;0;123;0
WireConnection;0;1;76;0
WireConnection;0;2;121;0
WireConnection;0;3;133;0
WireConnection;0;4;131;0
ASEEND*/
//CHKSM=54A0395F786C5DDB7A996244ACD2443D29298FD6