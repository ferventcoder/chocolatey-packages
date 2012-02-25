' Definition of custom attributes for declarative obfuscation.
' This file is only necessary for .NET Compact Framework and Silverlight projects.

Imports System
Imports System.Runtime.InteropServices

Namespace ObfuscationAttributes.System.Reflection
    ''' <summary>
    ''' Instructs obfuscation tools to use their standard obfuscation rules for the appropriate assembly type.
    ''' </summary>
    <ComVisible(True), AttributeUsage(AttributeTargets.Assembly, AllowMultiple:=False, Inherited:=False)> _
    NotInheritable Class ObfuscateAssemblyAttribute
        Inherits Attribute
        ''' <summary>
        ''' Initializes a new instance of the <see cref="ObfuscateAssemblyAttribute"/> class,
        ''' specifying whether the assembly to be obfuscated is public or private.
        ''' </summary>
        ''' <param name="assemblyIsPrivate"><c>true</c> if the assembly is used within the scope of one application; otherwise, <c>false</c>.</param>
        Public Sub New(ByVal assemblyIsPrivate As Boolean)
            m_assemblyIsPrivate = assemblyIsPrivate
            m_stripAfterObfuscation = True
        End Sub

        Private m_assemblyIsPrivate As Boolean

        ''' <summary>
        ''' Gets a boolean value indicating whether the assembly was marked private.
        ''' </summary>
        ''' <value>
        ''' <c>true</c> if the assembly was marked private; otherwise, <c>false</c>.
        ''' </value>
        Public ReadOnly Property AssemblyIsPrivate() As Boolean
            Get
                Return m_assemblyIsPrivate
            End Get
        End Property

        Private m_stripAfterObfuscation As Boolean

        ''' <summary>
        ''' Gets or sets a boolean value indicating whether the obfuscation tool should remove the attribute after processing.
        ''' </summary>
        ''' <value>
        ''' <c>true</c> if the obfuscation tool should remove the attribute after processing; otherwise, <c>false</c>.
        ''' The default value for this property is <c>true</c>.
        ''' </value>
        Public Property StripAfterObfuscation() As Boolean
            Get
                Return m_stripAfterObfuscation
            End Get
            Set(ByVal value As Boolean)
                m_stripAfterObfuscation = value
            End Set
        End Property
    End Class

    ''' <summary>
    ''' Instructs obfuscation tools to take the specified actions for an assembly, type, or member.
    ''' </summary>
    <ComVisible(True), AttributeUsage(AttributeTargets.[Delegate] Or AttributeTargets.Parameter Or AttributeTargets.[Interface] Or AttributeTargets.[Event] Or AttributeTargets.Field Or AttributeTargets.[Property] Or AttributeTargets.Method Or AttributeTargets.[Enum] Or AttributeTargets.Struct Or AttributeTargets.[Class] Or AttributeTargets.Assembly, AllowMultiple:=True, Inherited:=False)> _
    NotInheritable Class ObfuscationAttribute
        Inherits Attribute
        ''' <summary>
        ''' Initializes a new instance of the <see cref="ObfuscationAttribute"/> class.
        ''' </summary>
        Public Sub New()
            Me.m_applyToMembers = True
            Me.m_exclude = True
            Me.m_feature = "all"
            Me.m_stripAfterObfuscation = True
        End Sub

        Private m_applyToMembers As Boolean

        ''' <summary>
        ''' Gets or sets a boolean value indicating whether the attribute of a type is to apply to the members of the type.
        ''' </summary>
        ''' <value>
        ''' <c>true</c> if the attribute is to apply to the members of the type; otherwise, <c>false</c>. The default is <c>true</c>.
        ''' </value>
        Public Property ApplyToMembers() As Boolean
            Get
                Return m_applyToMembers
            End Get
            Set(ByVal value As Boolean)
                m_applyToMembers = value
            End Set
        End Property

        Private m_exclude As Boolean

        ''' <summary>
        ''' Gets or sets a boolean value indicating whether the obfuscation tool should exclude the type or member from obfuscation.
        ''' </summary>
        ''' <value>
        ''' <c>true</c> if the type or member to which this attribute is applied should be excluded from obfuscation; otherwise, <c>false</c>.
        ''' The default is <c>true</c>.
        ''' </value>
        Public Property Exclude() As Boolean
            Get
                Return m_exclude
            End Get
            Set(ByVal value As Boolean)
                m_exclude = value
            End Set
        End Property

        Private m_feature As String

        ''' <summary>
        ''' Gets or sets a string value that is recognized by the obfuscation tool, and which specifies processing options.
        ''' </summary>
        ''' <value>
        ''' A string value that is recognized by the obfuscation tool, and which specifies processing options. The default is "all".
        ''' </value>
        Public Property Feature() As String
            Get
                Return m_feature
            End Get
            Set(ByVal value As String)
                m_feature = value
            End Set
        End Property

        Private m_stripAfterObfuscation As Boolean

        ''' <summary>
        ''' Gets or sets a boolean value indicating whether the obfuscation tool should remove the attribute after processing.
        ''' </summary>
        ''' <value>
        ''' <c>true</c> if the obfuscation tool should remove the attribute after processing; otherwise, <c>false</c>.
        ''' The default value for this property is <c>true</c>.
        ''' </value>
        Public Property StripAfterObfuscation() As Boolean
            Get
                Return m_stripAfterObfuscation
            End Get
            Set(ByVal value As Boolean)
                m_stripAfterObfuscation = value
            End Set
        End Property
    End Class
End Namespace
