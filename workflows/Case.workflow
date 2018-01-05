<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Test_10</fullName>
        <field>Origin</field>
        <literalValue>Phone</literalValue>
        <name>Test 10</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Test Thomson</fullName>
        <actions>
            <name>Test_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Test_10</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Test_2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Test_3</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Test_4</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Test_5</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Test_6</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Test_7</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Test_8</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Test_9</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
